import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

import "../../Configs"
import "../../Shared"
import "../../Widgets/Screenshot"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24

    HyprlandFocusGrab {
        id: grab
        windows: [screenshotMenu]
        onCleared: screenshotMenu.closeWithAnimation()
    }

    IconImage {
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 18
        implicitHeight: 18
        source: Quickshell.iconPath("screenshooter-symbolic")
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            grab.active = true;
            screenshotMenu.show();
        }
    }

    ScreenshotMenu {
        id: screenshotMenu
    }
}
