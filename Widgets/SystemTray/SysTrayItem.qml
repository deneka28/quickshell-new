//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../../Shared"
import "../../Configs"

MouseArea {
    id: root
    required property SystemTrayItem modelData

    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    implicitWidth: 24
    implicitHeight: 24
    hoverEnabled: true

    HyprlandFocusGrab {
        id: grab
        windows: [trayPanel]
        onCleared: trayPanel.closeWithAnimation()
    }

    onClicked: event => {
        if (event.button === Qt.LeftButton) {
            if (trayPanel.shouldShow) {
                trayPanel.closeWithAnimation();
                grab.active = false;
            } else {
                grab.active = true;
                trayPanel.show();
            }
        } else if (event.button === Qt.RightButton) {
            if (root.modelData.hasMenu) {
                trayMenu.open();
            }
        } else if (event.button === Qt.MiddleButton) {
            modelData.activate();
        }
    }

    // Иконка приложения
    IconImage {
        id: trayIcon
        width: parent.implicitWidth
        height: parent.implicitHeight
        source: root.modelData.icon
        anchors.centerIn: parent

        // Подсветка при наведении
        opacity: root.containsMouse ? 0.7 : 1.0
        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }

        scale: root.containsMouse ? 1.15 : 1.0
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack
            }
        }
    }

    // Меню по правому клику
    QsMenuAnchor {
        id: trayMenu
        menu: root.modelData.menu
        anchor {
            window: this.QsWindow.window
            rect.x: root.x + QsWindow.window?.width
            rect.y: root.y + 16
        }
    }

    // Всплывающая панель
    PopupPanel {
        id: trayPanel
        direction: "down"
        anchors {
            top: true
            right: true
        }
        margins {
            top: 4
            right: 4
        }
        implicitWidth: 240
        implicitHeight: panelContent.implicitHeight + 24

        ColumnLayout {
            id: panelContent
            anchors {
                fill: parent
                margins: 12
            }
            spacing: 8

            // Заголовок — иконка + название
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                IconImage {
                    implicitWidth: 28
                    implicitHeight: 28
                    source: root.modelData.icon
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: root.modelData.title ?? ""
                        color: Config.colors.fontcolor
                        font.family: Config.font
                        font.pixelSize: 14
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    // Статус/подсказка
                    Text {
                        visible: text !== ""
                        text: root.modelData.tooltipDescription ?? ""
                        color: Config.colors.fontcolor
                        font.family: Config.font
                        font.pixelSize: 11
                        opacity: 0.6
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        Layout.maximumWidth: 180
                    }
                }
            }

            // Разделитель — только если есть меню
            Rectangle {
                visible: root.modelData.hasMenu
                Layout.fillWidth: true
                height: 1
                color: Config.colors.fontcolor
                opacity: 0.1
            }

            // Пункты меню
            TrayMenuItems {
                visible: root.modelData.hasMenu
                Layout.fillWidth: true
                menu: root.modelData.menu  // это QsMenuHandle — всё правильно
                onItemClicked: trayPanel.closeWithAnimation()
            }
        }
    }
}
