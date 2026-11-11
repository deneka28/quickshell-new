import QtQuick
import QtQuick.Layouts

import "../Configs"

Item {
    id: root

    property QtObject service

    anchors.fill: parent

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20

        spacing: 6

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.service.current.icon
            font.pixelSize: 64
            color: Config.colors.fontcolor
            font.family: "JetBrainsMono Nerd Font"
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.service.current.text
            font.pixelSize: 18
            font.bold: true
            color: Config.colors.fontcolor
            font.family: Config.font
        }
    }
}
