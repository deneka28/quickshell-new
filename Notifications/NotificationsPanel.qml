pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../Configs"
import "../Services"

Item {
    id: root

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // Заголовок + кнопка очистки
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Уведомления"
                font.pixelSize: 14
                font.bold: true
                font.family: Config.font
                color: Config.colors.fontcolor
                Layout.fillWidth: true
            }

            Rectangle {
                implicitHeight: 26
                implicitWidth: dndText.implicitWidth + 16
                radius: 6
                color: NotifServer.dnd ? "#f38ba8" : dndHover.containsMouse ? Config.colors.controlscolor : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }

                Text {
                    id: dndText
                    anchors.centerIn: parent
                    text: NotifServer.dnd ? "DND вкл" : "DND выкл"
                    font.pixelSize: 11
                    font.family: Config.font
                    color: NotifServer.dnd ? "#1e1e2e" : Config.colors.fontcolor
                }

                MouseArea {
                    id: dndHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: NotifServer.toggleDnd()
                }
            }

            Rectangle {
                visible: NotifServer.history.length > 0
                implicitHeight: 26
                implicitWidth: clearText.implicitWidth + 16
                radius: 6
                color: clearHover.containsMouse ? "#f38ba8" : Config.colors.controlscolor

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Text {
                    id: clearText
                    anchors.centerIn: parent
                    text: "Очистить"
                    font.pixelSize: 11
                    font.family: Config.font
                    color: clearHover.containsMouse ? "#1e1e2e" : Config.colors.fontcolor
                }

                MouseArea {
                    id: clearHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: NotifServer.clearHistory()
                }
            }
        }

        // Пусто
        Item {
            visible: NotifServer.history.length === 0
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "󰂛"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 36
                    color: Config.colors.fontcolor
                    opacity: 0.3
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Уведомлений нет"
                    font.pixelSize: 13
                    font.family: Config.font
                    color: Config.colors.fontcolor
                    opacity: 0.4
                }
            }
        }

        // Список уведомлений
        ScrollView {
            visible: NotifServer.history.length > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ListView {
                id: historyList
                spacing: 6
                model: NotifServer.history.slice().reverse()

                delegate: Rectangle {
                    id: notifItem
                    required property var modelData
                    required property int index

                    width: historyList.width
                    height: notifContent.implicitHeight + 16
                    radius: 8
                    color: itemHover.containsMouse ? Config.colors.widgetcolormidle : Config.colors.widgetcolor

                    Behavior on color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    RowLayout {
                        id: notifContent
                        anchors {
                            fill: parent
                            margins: 10
                        }
                        spacing: 10

                        // Иконка
                        Rectangle {
                            implicitWidth: 36
                            implicitHeight: 36
                            radius: 10
                            color: "transparent"
                            clip: true

                            Image {
                                anchors.fill: parent
                                source: notifItem.modelData.image || notifItem.modelData.appIcon
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                            }
                        }

                        // Контент
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 3

                            RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    text: notifItem.modelData.summary ?? ""
                                    font.bold: true
                                    font.pixelSize: 12
                                    font.family: Config.font
                                    color: Config.colors.fontcolor
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: notifItem.modelData.timeStr ?? ""
                                    font.pixelSize: 10
                                    font.family: Config.font
                                    color: Config.colors.fontcolor
                                    opacity: 0.5
                                }
                            }

                            Text {
                                visible: notifItem.modelData.body !== ""
                                text: notifItem.modelData.body ?? ""
                                font.pixelSize: 11
                                font.family: Config.font
                                color: Config.colors.fontcolor
                                opacity: 0.7
                                wrapMode: Text.Wrap
                                Layout.fillWidth: true
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                        }

                        // Кнопка удалить
                        Rectangle {
                            implicitWidth: 24
                            implicitHeight: 24
                            radius: 6
                            color: deleteHover.containsMouse ? "#f38ba8" : "transparent"
                            Behavior on color {
                                ColorAnimation {
                                    duration: 100
                                }
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                font.pixelSize: 11
                                color: deleteHover.containsMouse ? "#1e1e2e" : Config.colors.fontcolor
                                opacity: deleteHover.containsMouse ? 1 : 0.4
                            }

                            MouseArea {
                                id: deleteHover
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: NotifServer.removeFromHistory(notifItem.modelData)
                            }
                        }
                    }

                    MouseArea {
                        id: itemHover
                        anchors.fill: parent
                        hoverEnabled: true
                        z: -1
                    }
                }
            }
        }
    }
}
