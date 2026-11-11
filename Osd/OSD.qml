import QtQuick
import Quickshell
import Quickshell.Wayland
import "../Services"
import "../Configs"

PanelWindow {
    id: root

    property var _screen
    property bool hiding: false

    WlrLayershell.screen: root._screen
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    visible: OsdService.visible || osd.opacity > 0

    color: "transparent"

    implicitWidth: 320
    implicitHeight: 60

    anchors {
        bottom: true
    }

    margins.bottom: 50

    exclusionMode: ExclusionMode.Ignore

    Rectangle {
        id: osd

        anchors.fill: parent

        color: Config.colors.widgetcolor
        border.width: 1
        border.color: "#55ffffff"
        radius: 16

        opacity: OsdService.visible ? 1 : 0
        scale: OsdService.visible ? 1 : 0.92
        y: OsdService.visible ? 0 : 12

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutBack
            }
        }

        Behavior on y {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        OSDContent {
            anchors.fill: parent
        }
    }

    Connections {
        target: OsdService

        function onChanged() {
            hideTimer.stop();
            hideTimer.interval = OsdService.current.timeout;
            hideTimer.start();
        }
    }

    Timer {
        id: hideTimer

        onTriggered: {
            OsdService.visible = false;
        }
    }

    // Ждём завершения анимации исчезновения
    onVisibleChanged: {
        if (!OsdService.visible && root.visible) {
            closeTimer.start();
        }
    }

    Timer {
        id: closeTimer

        interval: 250

        onTriggered: {
            if (!OsdService.visible)
                root.visible = false;
        }
    }
}
