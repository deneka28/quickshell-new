pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Батарея
    property real percent: 0       // 0.0 - 1.0
    property bool charging: false
    property bool plugged: false
    property string status: ""     // Charging, Discharging, Full
    property int timeToEmpty: 0    // секунды
    property int timeToFull: 0     // секунды

    // Профиль энергосбережения
    property string activeProfile: "balanced" // performance, balanced, power-saver

    // Публичные методы
    function setProfile(profile) {
        setProfileProcess.command = ["powerprofilesctl", "set", profile];
        setProfileProcess.running = true;
    }

    function nextProfile() {
        switch (activeProfile) {
        case "performance":
            setProfile("balanced");
            break;
        case "balanced":
            setProfile("power-saver");
            break;
        case "power-saver":
            setProfile("performance");
            break;
        }
    }

    // Читаем батарею через inotifywait — мгновенная реакция
    Process {
        id: watchBattery
        command: ["inotifywait", "-m", "-e", "modify", "/sys/class/power_supply/BAT0/capacity", "/sys/class/power_supply/BAT0/status", "/sys/class/power_supply/ADP1/online"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line.includes("MODIFY")) {
                    readBattery.running = true;
                }
            }
        }
    }

    // Читаем данные батареи
    Process {
        id: readBattery
        command: ["bash", "-c", "echo $(cat /sys/class/power_supply/BAT0/capacity) " + "$(cat /sys/class/power_supply/BAT0/status) " + "$(cat /sys/class/power_supply/ADP1/online)"]
        running: true // запуск при старте

        stdout: SplitParser {
            onRead: line => {
                const parts = line.trim().split(" ");
                if (parts.length >= 3) {
                    root.percent = parseInt(parts[0]) / 100;
                    root.status = parts[1];
                    root.plugged = parts[2] === "1";
                    root.charging = parts[1] === "Charging";
                }
            }
        }
    }

    // Читаем активный профиль
    Process {
        id: readProfile
        command: ["powerprofilesctl", "get"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                const p = line.trim();
                if (p !== "")
                    root.activeProfile = p;
            }
        }
    }

    // Следим за изменением профиля
    Process {
        id: watchProfile
        command: ["bash", "-c", "dbus-monitor --system " + "\"type='signal',interface='net.hadess.PowerProfiles',member='PropertiesChanged'\""]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (line.includes("ActiveProfile") || line.includes("active-profile")) {
                    readProfile.running = true;
                }
            }
        }
    }

    // Установка профиля
    Process {
        id: setProfileProcess
        running: false
        onRunningChanged: {
            if (!running)
                readProfile.running = true;
        }
    }

    // Форматирование времени
    function formatTime(seconds) {
        if (seconds <= 0)
            return "";
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        if (h > 0)
            return `${h}ч ${m}м`;
        return `${m}м`;
    }

    // Иконка батареи
    property string icon: {
        const p = percent;
        if (charging)
            return "battery-caution-charging-symbolic";
        if (p >= 0.9)
            return "battery-full-symbolic";
        if (p >= 0.7)
            return "battery-good-symbolic";
        if (p >= 0.4)
            return "battery-medium-symbolic";
        if (p >= 0.2)
            return "battery-low-symbolic";
        return "battery-caution-symbolic";
    }

    // Иконка профиля
    property string profileIcon: {
        switch (activeProfile) {
        case "performance":
            return "power-profile-performance-symbolic";
        case "power-saver":
            return "power-profile-power-saver-symbolic";
        default:
            return "power-profile-balanced-symbolic";
        }
    }
}
