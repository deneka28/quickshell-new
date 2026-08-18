import QtQuick
import QtQuick.Layouts

import "../../Services"
import "../../Configs"

Item {
    id: kbLayout

    implicitHeight: 30
    implicitWidth: 30

    MouseArea {
        id: area

        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            KeyboardService.nextLayout();
        }
        onWheel: {
            KeyboardService.nextLayout();
        }
    }
    RowLayout {
        id: layout
        spacing: 2
        anchors.fill: parent
        Rectangle {
            Layout.preferredWidth: 28
            Layout.preferredHeight: 28
            color: "transparent"

            Text {
                id: indicator
                anchors.centerIn: parent
                text: KeyboardService.layout?.code.toUpperCase()
                color: Config.colors.fontcolor
                font.pixelSize: 16
                font.family: Config.font
                font.bold: true
            }
        }
    }
}
