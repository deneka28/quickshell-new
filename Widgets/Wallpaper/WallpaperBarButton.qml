pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Widgets
import QtQuick

import "../../Services"

Rectangle {
    id: root
    color: "transparent"
    implicitHeight: 24
    implicitWidth: 24

    IconImage {
        implicitWidth: 24
        implicitHeight: 24

        source: Quickshell.iconPath("preferences-desktop-wallpaper-symbolic")

        MouseArea {
            id: area
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    // Сменить обои сейчас
                    console.log("Manual wallpaper change requested");
                    WallpaperService.setRandomWallpaper();
                } else if (mouse.button === Qt.RightButton) {
                    // Включить/выключить автосмену
                    WallpaperService.toggleAutoChange();
                }
            }
        }
        scale: area.containsMouse ? 1.1 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 150
            }
        }
        // Индикатор автосмен
        Rectangle {
            visible: WallpaperService.autoChange
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 1
            anchors.rightMargin: 1
            width: 6
            height: 6
            radius: 3
            color: "#0cc0f2"
        }
    }
}
