import QtQuick

import "../Configs"

Text {
    property real fontSize: 14
    property color fontColor: Config.colors.fontcolor
    property string styledText: ""

    font.family: "SF Pro Display"
    font.pixelSize: fontSize
    color: fontColor

    text: qsTr(styledText)
}
