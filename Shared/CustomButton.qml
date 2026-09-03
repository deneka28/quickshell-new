import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../Configs"

Rectangle {
    id: root

    property var iconSource
    property var iconSize
    property string label
    property bool isLabel: false
    property bool isIcon: iconButton.source !== ""
    required property color btnColor

    implicitHeight: 28
    implicitWidth: iconButton.width + labelText.width + 20

    color: area.containsMouse ? Qt.rgba(root.btnColor.r, root.btnColor.g, root.btnColor.b, 0.15) : "transparent"

    Behavior on color {
        ColorAnimation {
            duration: 100
        }
    }

    radius: 6

    signal clicked

    RowLayout {
        spacing: 4
        anchors {
            fill: parent
            leftMargin: 8
            rightMargin: 8
        }
        IconImage {
            id: iconButton
            implicitWidth: 18
            implicitHeight: 18
            source: Quickshell.iconPath(root.iconSource)
            visible: source !== "" && status !== Image.Error
        }

        Text {
            id: labelText
            text: qsTr(root.label)
            color: area.containsMouse ? root.btnColor : Config.colors.fontcolor
            font.family: Config.font
            font.pixelSize: 13
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
        onClicked: root.clicked()
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }
}
