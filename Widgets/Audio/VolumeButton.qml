import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

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

    // HyprlandFocusGrab {
    //     id: grab
    //     windows: [volumeDock]
    //     onCleared: {
    //         volumeDock.closeWithAnimation();
    //     }
    // }

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
        // onWheel: event => {
        //     event.accepted = true;
        //     const delta = (event.angleDelta.y / 120) * 0.05;
        //     AudioService.volume = Math.max(0, Math.min(1, AudioService.volume + delta));
        // }
        onWheel: event => AudioService.changeVolume((event.angleDelta.y / 120) * 0.05)

        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton) {
                // AudioService.muted = !AudioService.muted;
                AudioService.toggleMute();
            }
            if (mouse.button === Qt.LeftButton) {
                // grab.active = true;
                // volumeDock.show();
            }
        }
    }
}
