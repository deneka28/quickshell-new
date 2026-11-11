import QtQuick

Item {
    id: root

    property int value: 0

    implicitHeight: 8

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        radius: height / 2
        color: "#40FFFFFF"
        height: 6
    }

    Rectangle {

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * root.value / 100
        height: 6
        radius: height / 2

        color: "#0009ff"

        Behavior on width {
            NumberAnimation {
                duration: 450
                easing.type: Easing.Linear
            }
        }
    }
}
