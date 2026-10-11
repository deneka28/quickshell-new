pragma Singleton
import Qt.labs.platform
import QtQuick
import Quickshell
import Quickshell.Io

import "../Configs"

Singleton {
    // Функции

    id: root

    // property string wallpaperDir: StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/wallpaper/"
    property string wallpaperDir: {
        let path = StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/wallpaper/";
        return path.replace("file://", "");
    }
    property int interval: 900 // 15 минут в секундах
    // property bool autoChange: Config.wallpaperAutoSwitch
    property string currentWallpaper: ""
    property url currentWallpaperUrl: ""

    property color accentColor: "#ff7900"
    property color dateTimeColor: "#ffffff"
    property list<color> listColor: []

    signal wallpaperChanged(string path)

    Connections {
        target: Config

        function onWallpaperAutoSwitchChanged() {
            autoChangeTimer.running = Config.wallpaperAutoSwitch;
            console.log("Wallpaper auto-change:", Config.wallpaperAutoSwitch ? "enabled" : "disabled");
        }
    }

    function setRandomWallpaper() {
        console.log("Getting random wallpaper from:", root.wallpaperDir);
        if (autoChangeTimer.running)
            autoChangeTimer.restart();

        getRandomFile.running = true;
    }

    function setWallpaperFile(path) {
        root.currentWallpaper = path;
        root.currentWallpaperUrl = "";

        Qt.callLater(() => {
            root.currentWallpaperUrl = "file://" + path;
        });

        setWallpaperProcess.command = ["awww", "img", path, "--transition-type", "fade", "--transition-fps", "60", "--transition-duration", "7"];

        console.log("Setting wallpaper:", path);

        setWallpaperProcess.running = true;

        if (autoChangeTimer.running)
            autoChangeTimer.restart();
    }

    function toggleAutoChange() {
        Config.wallpaperAutoSwitch = !Config.wallpaperAutoSwitch;
        console.log("Auto-change:", Config.wallpaperAutoSwitch ? "enabled" : "disabled");
    }

    function setInterval(seconds) {
        interval = seconds;
        console.log("Interval set to:", seconds, "seconds");
    }

    // Проверка и запуск swww daemon (только если не запущен)
    Process {
        id: checkDaemon

        running: true
        command: ["pgrep", "-x", "awww-daemon"]
        onExited: (code, status) => {
            if (code !== 0) {
                // Daemon не запущен, запускаем
                console.log("awww-daemon not running, starting...");
                swwwDaemon.running = true;
            } else {
                console.log("awww-daemon already running");
                // Сразу устанавливаем первый обои
                initTimer.start();
            }
        }
    }

    // Запуск swww daemon если нужно
    Process {
        id: swwwDaemon

        running: false
        command: ["awww-daemon"]
        onStarted: {
            console.log("awww-daemon started");
            // Даём время на инициализацию
            initTimer.start();
        }
        onExited: (code, status) => {
            console.log("awww-daemon exited:", code);
        }
    }

    // Таймер инициализации
    Timer {
        id: initTimer

        interval: 2000

        onTriggered: {
            if (!Config.wallpaperAutoSwitch) {
                console.log("Wallpaper auto-change disabled");
                return;
            }

            console.log("Setting initial random wallpaper...");
            root.setRandomWallpaper();
        }
    }

    // Процесс получения случайного файла
    Process {
        id: getRandomFile

        running: false
        command: ["sh", "-c", `find "${root.wallpaperDir}" -type f \\( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \\) | shuf -n 1`]
        onExited: (code, status) => {
            if (code !== 0)
                console.log("Failed to get random wallpaper");
        }

        stdout: SplitParser {
            onRead: data => {
                let path = data.trim();
                if (path && path !== "") {
                    console.log("Selected wallpaper:", path);
                    root.setWallpaperFile(path);
                }
            }
        }

        stderr: SplitParser {
            onRead: data => {
                console.log("Get random file error:", data);
            }
        }
    }

    // Процесс установки обоев
    Process {
        id: setWallpaperProcess

        running: false
        command: []
        onExited: (code, status) => {
            if (code === 0) {
                console.log("Wallpaper changed successfully");
                root.wallpaperChanged(root.currentWallpaper);
            } else {
                console.log("Failed to set wallpaper, code:", code);
            }
        }
        stderr: SplitParser {
            onRead: data => {
                console.log("Set wallpaper error:", data);
            }
        }
    }
    // Таймер автоматической смены
    Timer {
        id: autoChangeTimer

        interval: root.interval * 1000
        // running: root.autoChange
        running: Config.wallpaperAutoSwitch
        repeat: true
        onTriggered: {
            console.log("Auto-change triggered");
            root.setRandomWallpaper();
        }
    }
    ColorQuantizer {
        id: quantizer

        source: root.currentWallpaperUrl
        depth: 3
        rescaleSize: 128
        onColorsChanged: {
            if (colors.length > 0) {
                root.accentColor = colors[0];
                root.dateTimeColor = colors[7];
                root.listColor = [...colors];
            }
        }
    }
}
