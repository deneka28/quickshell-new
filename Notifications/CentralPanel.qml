pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell

import "../Shared"
import "../Configs"
import "../Widgets/Calendar"
import "../Services"

PopupPanel {
    id: root
    direction: "down"
    anchors {
        top: true
    }
    margins {
        top: 4
    }
    implicitWidth: 380
    implicitHeight: 560

    exclusionMode: ExclusionMode.Normal

    // Текущая вкладка
    property int currentTab: 0 // 0 — календарь, 1 — уведомления

    ColumnLayout {
        anchors {
            fill: parent
            margins: 12
        }
        spacing: 8

        // Табы
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            // Вкладка календаря
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 8
                color: root.currentTab === 0 ? Config.colors.controlscolor : tabCalHover.containsMouse ? Qt.rgba(1, 1, 1, 0.05) : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: ""
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: Config.colors.fontcolor
                        opacity: root.currentTab === 0 ? 1 : 0.5
                    }

                    Text {
                        text: "Календарь"
                        font.family: Config.font
                        font.pixelSize: 13
                        font.bold: root.currentTab === 0
                        color: Config.colors.fontcolor
                        opacity: root.currentTab === 0 ? 1 : 0.5
                    }
                }

                MouseArea {
                    id: tabCalHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.currentTab = 0
                }
            }

            // Вкладка уведомлений
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 32
                radius: 8
                color: root.currentTab === 1 ? Config.colors.controlscolor : tabNotifHover.containsMouse ? Qt.rgba(1, 1, 1, 0.05) : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: "󰂚"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 14
                        color: Config.colors.fontcolor
                        opacity: root.currentTab === 1 ? 1 : 0.5
                    }

                    Text {
                        text: "Уведомления"
                        font.family: Config.font
                        font.pixelSize: 13
                        font.bold: root.currentTab === 1
                        color: Config.colors.fontcolor
                        opacity: root.currentTab === 1 ? 1 : 0.5
                    }

                    // Бейдж с количеством
                    Rectangle {
                        visible: NotifServer.history.length > 0
                        implicitWidth: Math.max(18, countText.implicitWidth + 8)
                        implicitHeight: 18
                        radius: 9
                        color: "#f38ba8"

                        Text {
                            id: countText
                            anchors.centerIn: parent
                            text: NotifServer.history.length
                            font.pixelSize: 10
                            font.bold: true
                            color: "#1e1e2e"
                        }
                    }
                }

                MouseArea {
                    id: tabNotifHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.currentTab = 1
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 1
            color: Config.colors.fontcolor
            opacity: 0.08
        }

        // Контент
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: root.currentTab

            // Вкладка 1 — Календарь
            CalendarWidget {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Вкладка 2 — Уведомления
            NotificationsPanel {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
