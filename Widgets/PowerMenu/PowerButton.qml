import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../../Configs"

Rectangle {
    id: root

    required property string icon
    required property string label
    required property color btnColor

    signal triggered

    implicitHeight: 36
    radius: 8
    color: area.containsMouse ? Qt.rgba(root.btnColor.r, root.btnColor.g, root.btnColor.b, 0.15) : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
        }
        spacing: 8

        IconImage {
            implicitWidth: 18
            implicitHeight: 18
            source: Quickshell.iconPath(root.icon)
        }

        Text {
            text: root.label
            color: area.containsMouse ? root.btnColor : Config.colors.fontcolor
            font.family: Config.font
            font.pixelSize: 13
            Layout.fillWidth: true

            Behavior on color {
                ColorAnimation {
                    duration: 100
                }
            }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.triggered()
    }
}
