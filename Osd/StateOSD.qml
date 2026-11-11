import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property QtObject service

    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8

        Text {
            Layout.alignment: Qt.AlignHCenter

            text: root.service.current.icon
            font.pixelSize: 28
            color: "white"
        }

        Text {
            Layout.alignment: Qt.AlignHCenter

            text: root.service.current.title
            font.pixelSize: 18
            font.bold: true
            color: "white"
        }

        Text {
            Layout.alignment: Qt.AlignHCenter

            text: root.service.current.text
            font.pixelSize: 15
            color: "#CCCCCC"
        }
    }
}
