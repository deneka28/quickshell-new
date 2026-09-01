pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../../Shared"
import "../../Configs"
import "../../Services"

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
        ColumnLayout {
            id: columnLayout
            anchors.fill: contentRect
            Layout.alignment: Qt.AlignHCenter
            spacing: 5
            Text {
                id: head
                Layout.fillWidth: true
                text: qsTr("Питание и подсветка")
                font.family: Config.font
                font.pixelSize: 24
                color: Config.colors.fontcolor
                leftPadding: 20
            }
            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                spacing: 2
                RowLayout {
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true
                    Layout.leftMargin: 20
                    IconImage {
                        id: iconBat
                        source: Quickshell.iconPath(BatteryService.icon)
                        implicitSize: 36
                    }
                    Text {
                        id: percentage
                        Layout.fillWidth: true
                        text: qsTr(" Уровень заряда: " + (BatteryService.percent * 100).toFixed(0) + "%")
                        font.family: Config.font
                        font.pixelSize: 16
                        color: Config.colors.fontcolor
                        leftPadding: 20
                    }
                }
                Text {
                    id: status

                    text: {
                        const hours = (BatteryService.status === "Charging" ? BatteryService.timeToFull : BatteryService.timeToEmpty) / 3600;
                        return `${BatteryService.status}    ${hours.toFixed(2)} Ч`;
                    }
                    font.family: Config.font
                    font.pixelSize: 12
                    color: Config.colors.fontcolor
                    leftPadding: 20
                }
            }

            RowLayout {
                id: layout
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
                spacing: 8

                ProfileButton {
                    profile: "power-saver"
                    icon: "power-profile-power-saver-symbolic"
                    label: "Экономия"
                }

                ProfileButton {
                    profile: "balanced"
                    icon: "power-profile-balanced-symbolic"
                    label: "Баланс"
                }

                ProfileButton {
                    profile: "performance"
                    icon: "power-profile-performance-symbolic"
                    label: "Макс"
                }
            }
        }
    }
}
