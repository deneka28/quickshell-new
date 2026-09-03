import QtQuick
import Quickshell
import Quickshell.Widgets

import "../../Shared"
import "../../Configs"
import "../../Services"

CircleProgress {
    id: root
    size: 26
    colorCircle: Config.colors.fontcolor
    colorBackground: Config.colors.bgcolor
    showBackground: false
    arcBegin: 0
    arcOffset: 220
    arcEnd: 280 * Math.min(1, AudioService.volume)
    lineWidth: 2
    anchors.verticalCenter: parent.verticalCenter

    IconImage {
        id: icon
        implicitHeight: 14
        implicitWidth: 14
        anchors.centerIn: parent
        source: {
            const v = AudioService.volume;
            if (AudioService.muted)
                return Quickshell.iconPath("audio-volume-muted-symbolic");
            if (v >= 0.66)
                return Quickshell.iconPath("audio-volume-high-symbolic");
            if (v >= 0.33)
                return Quickshell.iconPath("audio-volume-medium-symbolic");
            return Quickshell.iconPath("audio-volume-low-symbolic");
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
        onWheel: event => AudioService.changeVolume((event.angleDelta.y / 120) * 0.05)

        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton) {
                AudioService.toggleMute();
            }
            if (mouse.button === Qt.LeftButton) {}
        }
    }
}
