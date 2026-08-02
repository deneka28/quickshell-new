import QtQuick
import Quickshell.Services.UPower
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell

import "../../Shared"
import "../../Services"
import "../../Configs"

CircleProgress {
    id: root
    size: 26
    property bool isLowBatt: BatteryService.percent > 0.3
    colorCircle: isLowBatt ? Config.colors.fontcolor : Config.colors.red900
    colorBackground: Config.colors.bgcolor
    showBackground: true
    arcBegin: 0
    arcOffset: 220
    arcEnd: 280 * BatteryService.percent
    lineWidth: 2

    IconImage {
        source: Quickshell.iconPath(BatteryService.icon)
        implicitHeight: 16
        implicitWidth: 16
        anchors.centerIn: parent
    }

    BatteryProfile {
        id: powerProfile
    }

    MouseArea {
        id: area
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: {
            grab.active = true;
            powerProfile.show();
        }
    }
    HyprlandFocusGrab {
        id: grab

        windows: [powerProfile]
        onCleared: {
            powerProfile.closeWithAnimation();
        }
    }
}
