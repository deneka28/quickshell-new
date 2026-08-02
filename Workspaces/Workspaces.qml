pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    height: 14
    width: 190

    color: "transparent"
    WorkspaceIPC {
        id: workspaces
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.topMargin: 2
        anchors.bottomMargin: 2
        anchors.leftMargin: 6
        anchors.rightMargin: 6
        Layout.alignment: Qt.AlignVCenter
        spacing: -2

        Repeater {
            model: workspaces.amount

            WorkspaceElem {
                required property int modelData
                wnum: modelData + 1
            }
        }
    }
}
