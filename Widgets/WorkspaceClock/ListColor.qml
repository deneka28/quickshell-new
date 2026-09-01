pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "../../Services"

PanelWindow {
    id: root

    implicitWidth: 200
    implicitHeight: 400
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    anchors {
        top: true
        bottom: false
        left: false
        right: true
    }
    margins {
        top: 100
        right: 100
        left: 100
    }

    ListView {
        id: colorList

        width: parent.width
        height: parent.height
        spacing: 5

        model: WallpaperService.listColor

        delegate: Rectangle {
            required property var modelData
            required property int index
            radius: 5
            width: parent.width
            height: 40

            color: modelData

            Text {
                anchors.centerIn: parent
                text: index + ": " + modelData
                color: "black"
            }
        }
    }
}
