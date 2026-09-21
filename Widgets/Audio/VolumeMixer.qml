pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

import "../../Shared"

PopupPanel {
    id: slidingPopup

    direction: "down" // left, right, up, down
    anchors {
        top: true
        left: false
        right: true
    }
    margins {
        // top: 4
        right: 4
    }
    implicitWidth: 400
    implicitHeight: 200
    visible: open
    property bool open: false
    color: "transparent"
    contentItem: Rectangle {
        id: contentRect
        implicitHeight: parent.height
        implicitWidth: parent.width
        color: "transparent"

        ScrollView {
            anchors.fill: parent
            contentWidth: availableWidth

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                PwNodeLinkTracker {
                    id: linkTracker
                    node: Pipewire.defaultAudioSink
                }
                Volume {
                    node: Pipewire.defaultAudioSink
                }
                Rectangle {
                    Layout.fillWidth: true
                    color: palette.active.text
                    implicitHeight: 1
                    opacity: 0.3
                }
                Repeater {
                    model: linkTracker.linkGroups

                    Volume {
                        required property PwLinkGroup modelData
                        node: modelData.source
                    }
                }
            }
        }
    }
}
