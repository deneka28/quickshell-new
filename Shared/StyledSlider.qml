import QtQuick
import QtQuick.Controls

Slider {
    id: control
    value: 0.5

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 300
        implicitHeight: 6
        width: control.availableWidth
        height: implicitHeight
        radius: 8
        color: "#2b2b2b"
        // border.color: "green"
        // border.width: 2

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#083cd5"
            radius: 8
            border.color: "transparent"
            border.width: 2
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        // color: "#ffffff"
        color: "#083cd5"
        border.color: "grey"
        border.width: 4
    }
}
