import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../../Configs"
import "../../Services"

Rectangle {
    id: root

    required property string profile
    required property string icon
    required property string label

    property bool isActive: BatteryService.activeProfile === profile

    implicitWidth: btnLayout.implicitWidth + 16
    implicitHeight: btnLayout.implicitHeight + 10
    radius: 8

    // Фон — подсветка активного профиля
    color: {
        if (isActive) {
            switch (profile) {
            case "performance":
                return "#45273a"; // красноватый
            case "balanced":
                return "#2a3f5f"; // синий
            case "power-saver":
                return "#2a4a3a"; // зелёный
            }
        }
        return hoverArea.containsMouse ? Config.colors.controlscolor : "transparent";
    }

    border.width: isActive ? 1 : 0
    border.color: {
        switch (profile) {
        case "performance":
            return "#f38ba8";
        case "balanced":
            return "#89b4fa";
        case "power-saver":
            return "#a6e3a1";
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    RowLayout {
        id: btnLayout
        anchors.centerIn: parent
        spacing: 6

        IconImage {
            implicitWidth: 16
            implicitHeight: 16
            source: Quickshell.iconPath(root.icon)

            // Цвет иконки через colorize
            layer.enabled: true
            layer.effect: null
        }

        Text {
            text: root.label
            font.family: Config.font
            font.pixelSize: 12
            font.bold: root.isActive
            color: {
                if (root.isActive) {
                    switch (root.profile) {
                    case "performance":
                        return "#f38ba8";
                    case "balanced":
                        return "#89b4fa";
                    case "power-saver":
                        return "#a6e3a1";
                    }
                }
                return Config.colors.fontcolor;
            }

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onClicked: BatteryService.setProfile(root.profile)
    }
}
