pragma Singleton

import QtQuick
import Quickshell
import "../Osd"

Singleton {
    id: root

    property bool visible: false
    property bool keyboardInitialized: false
    property var current: ({
            type: Types.mNone,
            icon: "",
            title: "",
            value: 0,
            text: "",
            timeout: 1500
        })

    // Не показываем OSD при первом чтении яркости
    property bool brightnessInitialized: false

    signal changed

    function show(type, icon, title, value, text, timeout) {
        current = {
            type: type,
            icon: icon,
            title: title,
            value: Math.round(value),
            text: text,
            timeout: timeout
        };

        visible = true;
        changed();
    }

    function showVolume() {
        if (!AudioService.ready)
            return;
        const muted = AudioService.muted;
        const volume = muted ? 0 : AudioService.volume * 100;

        show(Types.mVolume, muted ? "󰝟" : volume < 50 ? "󰖀" : "󰕾", qsTr("Volume"), volume, "", 1500);
    }

    function showBrightness(value) {
        show(Types.mBrightness, value < 30 ? "󰃞" : "󰃠", qsTr("Brightness"), value, "", 1500);
    }

    function showCaps(enabled) {
        show(Types.mCapsLock, "󰪛", qsTr("Caps Lock"), 0, enabled ? qsTr("Enabled") : qsTr("Disabled"), 1500);
    }

    function showLayout(layout) {
        show(Types.mLayout, "󰌌", qsTr("Keyboard layout"), 0, layout, 1500);
    }

    // Отслеживание громкости и mute
    Connections {
        target: AudioService.sink?.audio ?? null

        function onVolumeChanged() {
            root.showVolume();
        }

        function onMutedChanged() {
            root.showVolume();
        }
    }

    // Отслеживание яркости
    Connections {
        target: Brightness

        function onChanged() {
            if (!root.brightnessInitialized) {
                root.brightnessInitialized = true;
                return;
            }

            root.showBrightness(Brightness.value);
        }
    }
    Connections {
        target: KeyboardService

        function onLayoutChanged() {
            if (!KeyboardService.layout)
                return;
            root.showLayout(KeyboardService.layout.label);
        }

        function onCapsLockChanged() {
            root.showCaps(KeyboardService.capsLock);
        }
    }
}
