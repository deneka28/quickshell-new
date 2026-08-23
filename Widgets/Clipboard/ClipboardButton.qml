pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import "../../Configs"
import "../../Services"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    HyprlandFocusGrab {
        id: grab
        windows: [clipboardPanel]
        onCleared: clipboardPanel.closeWithAnimation()
    }

    IconImage {
        anchors.centerIn: parent
        implicitWidth: 18
        implicitHeight: 18
        source: ClipboardService.clipHistCount > 0
            ? Quickshell.iconPath("clipboard-text-outline-symbolic")
            : Quickshell.iconPath("clipboard-outline-symbolic")
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton) {
                if (clipboardPanel.shouldShow) {
                    grab.active = false
                    clipboardPanel.closeWithAnimation()
                } else {
                    ClipboardService.refreshList()
                    grab.active = true
                    clipboardPanel.show()
                }
            } else if (mouse.button === Qt.RightButton) {
                ClipboardService.runningWipe = true
                ClipboardService.runningCount = true
            }
        }
    }

    ClipboardPanel {
        id: clipboardPanel
    }
}
