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
        top: 4
        right: 4
    }
    implicitWidth: contentRect.width
    implicitHeight: contentRect.height
    visible: open
    property bool open: false
    color: "transparent"
    cornerRadius: 5

    contentItem: Rectangle {
        id: contentRect
        anchors.centerIn: parent
        color: Config.colors.widgetcolor
        implicitHeight: slidingPopup.implicitHeight - 4
        implicitWidth: slidingPopup.implicitWidth - 4
        radius: 8
        width: 400
        height: 200
        Text {
            id: head

            text: qsTr("Питание и подсветка")
            font.family: Config.font
            font.pixelSize: 24
            color: Config.colors.fontcolor
            leftPadding: 8
        }
        ColumnLayout {
            id: columnLayout
            anchors.centerIn: parent
            spacing: 15

            ColumnLayout {
                spacing: 2
                RowLayout {
                    Layout.alignment: Qt.AlignCenter
                    IconImage {
                        id: iconBat
                        source: Quickshell.iconPath(BatteryService.icon)
                        implicitSize: 36
                    }
                    Text {
                        id: percentage

                        text: qsTr(" Уровень заряда: " + BatteryService.percentage * 100 + "%")
                        font.family: Config.font
                        font.pixelSize: 16
                        color: Config.colors.fontcolor
                    }
                }
                // Text {
                //     id: status
                //     text: qsTr(BatteryService.status + "    " +
                //                 (BatteryService.timeToEmpty / 3600).toFixed(2) + " Ч")
                //     font.family: Config.font
                //     font.pixelSize: 12
                //     color: Config.colors.fontcolor
                //     leftPadding: iconBat.implicitSize + 10
                // }
                Text {
                    id: status

                    text: {
                        const hours = (BatteryService.status === "Charging" ? BatteryService.timeToFull : BatteryService.timeToEmpty) / 3600;
                        return `${BatteryService.status}    ${hours.toFixed(2)} Ч`;
                    }

                    font.family: Config.font
                    font.pixelSize: 12
                    color: Config.colors.fontcolor
                    leftPadding: iconBat.implicitSize + 10
                }
            }
            RowLayout {
                id: layout
                Layout.alignment: Qt.AlignCenter
                spacing: 4
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
