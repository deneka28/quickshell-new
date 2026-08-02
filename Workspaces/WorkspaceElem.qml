import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

// import qs
import "../Configs"

Rectangle {
    id: root

    required property int wnum

    property bool hovered: false
    property bool active: workspaces.active === wnum || hovered
    property int activeMargin: 6
    property int inactiveMargin: 2

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.rightMargin: activeMargin
    Layout.leftMargin: inactiveMargin
    function updateGeometry(w, h) {
        root.Layout.minimumHeight = h;
        root.Layout.maximumHeight = h;
        root.Layout.minimumWidth = w;
        root.Layout.maximumWidth = w;
    }

    onWidthChanged: updateGeometry(width, height)
    onHeightChanged: updateGeometry(width, height)

    color: Config.colors.fontcolor
    radius: 10

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true

        onClicked: () => {
            workspaces.switchWorkspace(wnum);
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 150
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: 250
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 450
        }
    }
    Behavior on radius {
        NumberAnimation {
            duration: 250
        }
    }

    scale: area.containsMouse ? 1.2 : 1.0

    states: [
        State {
            name: "horizontalActive"
            when: root.active
            PropertyChanges {
                target: root
                width: 40
                height: 7
                opacity: 1
            }
        },
        State {
            name: "horizontalInactive"
            when: !root.active
            PropertyChanges {
                target: root
                height: 7
                width: 7
                opacity: 0.5
            }
        }
    ]
}
