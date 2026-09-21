pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int value: 0
    property int maximum: 100

    signal changed

    // Получение текущей яркости
    Process {
        id: reader

        command: ["brightnessctl", "-m"]

        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(",");

                if (parts.length < 5)
                    return;
                const current = parseInt(parts[2]);
                const max = parseInt(parts[4]);

                if (isNaN(current) || isNaN(max) || max <= 0)
                    return;
                const newValue = Math.round(current / max * 100);

                if (root.value !== newValue) {
                    root.value = newValue;
                    root.changed();
                }
            }
        }
    }

    // Изменение яркости из QML
    Process {
        id: setter

        property int target: 0

        command: ["brightnessctl", "set", target + "%"]

        onExited: {
            root.refresh();
        }
    }

    // Проверяем яркость
    Timer {
        id: pollTimer

        interval: 100
        repeat: true
        running: true

        onTriggered: {
            root.refresh();
        }
    }

    function refresh() {
        if (!reader.running)
            reader.running = true;
    }

    function set(percent) {
        percent = Math.max(1, Math.min(100, Math.round(percent)));

        if (percent === root.value)
            return;
        setter.target = percent;
        setter.running = true;
    }

    function increase(step = 5) {
        set(root.value + step);
    }

    function decrease(step = 5) {
        set(root.value - step);
    }

    Component.onCompleted: {
        refresh();
    }
}
