import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import "../Configs"
import "../Shared"
import "../Widgets/PowerMenu"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    HyprlandFocusGrab {
        id: grab
        windows: [powerMenu]
        onCleared: powerMenu.closeWithAnimation()
    }

    IconImage {
        anchors.centerIn: parent
        implicitWidth: 18
        implicitHeight: 18
        source: Quickshell.iconPath("system-shutdown-symbolic")

        scale: area.containsMouse ? 1.15 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            grab.active = true;
            powerMenu.show();
        }
    }

    PowerMenu {
        id: powerMenu
    }
}
