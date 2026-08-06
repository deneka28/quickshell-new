import QtQuick
import Quickshell
import Quickshell.Widgets

Rectangle {
    id: root

    property var iconSource
    property string laybel

    implicitHeight: 30
    implicitWidth: 30

    color: "transparent"

    radius: 5

    signal clicked

    Image {
        id: ionButton
        anchors.fill: parent
        anchors.margins: 2
        anchors.centerIn: parent
        cache: true
        fillMode: Image.PreserveAspectCrop
        source: root.iconSource
    }

    MouseArea {
        id: area
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
