pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../../Shared"
import "../../Configs"
import "../../Services"

PopupPanel {
    id: slidingPopup

    direction: "down" // left, right, up, down
    anchors {
        top: true
        left: true
        right: false
    }
    margins {
        top: 4
        left: 4
    }
    implicitWidth: contentRect.width
    implicitHeight: contentRect.height
    visible: open
    property bool open: false
    color: "transparent"
    cornerRadius: 5

    contentItem: Rectangle {
        id: contentRect
        anchors.centerIn: parent
        color: Config.colors.widgetcolor
        implicitHeight: slidingPopup.implicitHeight - 4
        implicitWidth: slidingPopup.implicitWidth - 4
        radius: 8
        width: 400
        height: 200
    }
}
