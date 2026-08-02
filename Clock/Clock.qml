import QtQuick
import Quickshell.Hyprland

import "../Services"
import "../Configs"

Rectangle {
    id: root
    color: "transparent"
    implicitWidth: 140
    implicitHeight: 14
    // border.width: 1

    // HyprlandFocusGrab {
    //     id: grab
    //     windows: [centralDock]
    //     onCleared: {
    //         centralDock.closeWithAnimation()
    //     }
    // }

    // MouseArea {
    //     id: area
    //     anchors.fill: parent
    //     hoverEnabled: true
    //     onClicked: {
    //         grab.active = true
    //         centralDock.show()
    //     }
    // }

    property string format: "hh:mm    dd.MM.yyyy"
    Text {
        id: textItem
        anchors.centerIn: parent
        text: Time.format(root.format)
        font.family: Config.font
        color: Config.colors.fontcolor
        font.pixelSize: 16
    }
    // CentralDock {
    //     id: centralDock
    // }
}
