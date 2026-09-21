import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell
import qs.Configs

import "../Shared"

Rectangle {
    id: root
    implicitHeight: 34
    implicitWidth: 350
    anchors.leftMargin: 4
    color: "transparent"

    property string fullTitle: ToplevelManager.activeToplevel?.activated ? ToplevelManager.activeToplevel.title : ""

    // Разбиваем по " — "
    property var parts: fullTitle.split(" — ")
    property string appPart: parts[0] ?? ""
    property string filePart: parts.length > 1 ? parts.slice(1).join(" — ") : ""

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        spacing: 0

        // Иконка
        IconImage {
            visible: root.fullTitle !== ""
            source: root.fullTitle !== "" ? Quickshell.iconPath(ToplevelManager.activeToplevel.appId, "application-x-executable") : ""
            implicitHeight: 20
            implicitWidth: 20
            Layout.alignment: Qt.AlignVCenter
            Layout.rightMargin: 6
        }

        // Название приложения — яркое
        StyledText {
            visible: root.appPart !== ""
            styledText: root.appPart
            font.bold: true
            Layout.alignment: Qt.AlignVCenter
            elide: Text.ElideRight
            Layout.maximumWidth: root.filePart !== "" ? 140 : root.width - 40
        }

        // Разделитель
        StyledText {
            visible: root.filePart !== ""
            styledText: " — "
            Layout.alignment: Qt.AlignVCenter
        }

        // Имя файла — тусклое
        StyledText {
            visible: root.filePart !== ""
            styledText: root.filePart
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            elide: Text.ElideRight
        }

        Item {
            Layout.fillWidth: true
        }
    }

    // Плавная смена при переключении окна
    Behavior on fullTitle {
        SequentialAnimation {
            NumberAnimation {
                target: root
                property: "opacity"
                to: 0
                duration: 100
            }
            PropertyAction {}
            NumberAnimation {
                target: root
                property: "opacity"
                to: 1
                duration: 150
            }
        }
    }
}
