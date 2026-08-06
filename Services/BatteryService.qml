pragma Singleton
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower
import QtQuick

Singleton {
    id: root

    // Батарея через UPower — реактивно
    property var device: UPower.displayDevice

    property real percent: device?.percentage ?? 0
    property bool charging: device?.state === UPowerDeviceState.Charging
    property bool plugged: !UPower.onBattery
    property string status: {
        switch (device?.state) {
        case UPowerDeviceState.Charging:
            return "Charging";
        case UPowerDeviceState.Discharging:
            return "Discharging";
        case UPowerDeviceState.FullyCharged:
            return "Full";
        case UPowerDeviceState.PendingCharge:
            return "PendingCharge";
        case UPowerDeviceState.PendingDischarge:
            return "PendingDischarge";
        default:
            return "";
        }
    }

    // Время до разрядки/зарядки в секундах
    property int timeToEmpty: device?.timeToEmpty ?? 0
    property int timeToFull: device?.timeToFull ?? 0

    // Профиль энергосбережения
    property string activeProfile: "balanced"

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

    // Читаем профиль при старте
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

    // Следим за изменением профиля через DBus
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
        if (charging) {
            if (p >= 0.9)
                return "battery-full-charging-symbolic";
            if (p >= 0.7)
                return "battery-good-charging-symbolic";
            if (p >= 0.4)
                return "battery-medium-charging-symbolic";
            return "battery-low-charging-symbolic";
        }
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
