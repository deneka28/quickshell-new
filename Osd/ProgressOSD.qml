import QtQuick
import QtQuick.Layouts

import "../Services"
import "../Configs"

Item {
    id: root
    anchors.fill: parent

    property int value: OsdService.current.value

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 20

        spacing: 12

        Text {
            text: OsdService.current.icon
            font.pixelSize: 64
            color: Config.colors.fontcolor
            font.family: "JetBrainsMono Nerd Font"

            Layout.alignment: Qt.AlignVCenter
        }

        ProgressBarM {
            Layout.fillWidth: true
            Layout.preferredHeight: 10
            Layout.alignment: Qt.AlignVCenter

            value: root.value
        }

        Text {
            text: root.value + "%"
            font.pixelSize: 16
            color: Config.colors.fontcolor
            font.family: Config.font.family

            Layout.alignment: Qt.AlignVCenter
        }
    }
}
