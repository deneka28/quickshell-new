import QtQuick
import QtQuick.Layouts
import "../Configs"

Rectangle {
    id: root

    default property alias content: layout.data

    color: Config.colors.controlscolor
    radius: 8

    implicitWidth: layout.implicitWidth + 16
    implicitHeight: layout.implicitHeight + 8

    RowLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: 8
        spacing: 6
        // anchors.verticalCenter: parent.verticalCenter
    }
}
