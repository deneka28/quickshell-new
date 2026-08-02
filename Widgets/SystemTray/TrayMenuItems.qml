//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import "../../Configs"

ColumnLayout {
    id: root
    required property QsMenuHandle menu
    signal itemClicked

    spacing: 2

    // QsMenuOpener даёт доступ к дочерним элементам меню
    QsMenuOpener {
        id: menuOpener
        menu: root.menu
    }

    Repeater {
        model: menuOpener.children
        delegate: Item {
            id: delegateItem
            required property QsMenuEntry modelData
            Layout.fillWidth: true
            // Вложенное меню — рекурсивно
            QsMenuOpener {
                id: subMenuOpener
                menu: modelData.hasChildren ? modelData : null
            }
            // Разделитель
            Rectangle {
                visible: modelData.isSeparator
                anchors.centerIn: parent
                width: parent.width
                height: 1
                color: Config.colors.fontcolor
                opacity: 0.1
            }
            // Пункт меню
            Rectangle {
                id: menuItemRect
                visible: !modelData.isSeparator
                anchors.fill: parent
                radius: 6
                color: itemHover.containsMouse || subMenu.visible ? Config.colors.controlscolor : "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
                RowLayout {
                    anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 10
                    }
                    spacing: 8
                    Image {
                        visible: modelData.icon?.toString() !== ""
                        width: 16
                        height: 16
                        source: modelData.icon ?? ""
                        sourceSize.width: 16
                        sourceSize.height: 16
                    }
                    Text {
                        text: modelData.text ?? ""
                        color: modelData.enabled ? Config.colors.fontcolor : Qt.rgba(Config.colors.fontcolor.r, Config.colors.fontcolor.g, Config.colors.fontcolor.b, 0.4)
                        font.family: Config.font
                        font.pixelSize: 13
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }
                    // Галочка
                    Text {
                        visible: modelData.checkState !== Qt.Unchecked
                        text: "✓"
                        color: Config.colors.fontcolor
                        font.pixelSize: 13
                        opacity: 0.7
                    }
                    // Стрелка если есть подменю
                    Text {
                        visible: modelData.hasChildren
                        text: "›"
                        color: Config.colors.fontcolor
                        font.pixelSize: 16
                        opacity: 0.6
                    }
                }
                MouseArea {
                    id: itemHover
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: modelData.enabled

                    onClicked: {
                        if (modelData.hasChildren) {
                            subMenu.visible = !subMenu.visible;
                        } else {
                            modelData.triggered();
                            root.itemClicked();
                        }
                    }
                }
            }
            // Подменю — разворачивается под пунктом
            ColumnLayout {
                id: subMenu
                visible: false
                anchors {
                    top: menuItemRect.bottom
                    left: parent.left
                    right: parent.right
                    leftMargin: 12
                }
                spacing: 2
                // Рекурсивно рендерим подменю
                Repeater {
                    model: subMenuOpener.children
                    delegate: Item {
                        required property QsMenuEntry modelData
                        Layout.fillWidth: true
                        height: modelData.isSeparator ? 8 : 32

                        Rectangle {
                            visible: modelData.isSeparator
                            anchors.centerIn: parent
                            width: parent.width
                            height: 1
                            color: Config.colors.fontcolor
                            opacity: 0.1
                        }
                        Rectangle {
                            visible: !modelData.isSeparator
                            anchors.fill: parent
                            radius: 6
                            color: subItemHover.containsMouse ? Config.colors.controlscolor : "transparent"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 100
                                }
                            }

                            RowLayout {
                                anchors {
                                    fill: parent
                                    leftMargin: 10
                                    rightMargin: 10
                                }
                                spacing: 8

                                Image {
                                    visible: modelData.icon?.toString() !== ""
                                    width: 14
                                    height: 14
                                    source: modelData.icon ?? ""
                                    sourceSize.width: 14
                                    sourceSize.height: 14
                                }

                                Text {
                                    text: modelData.text ?? ""
                                    color: modelData.enabled ? Config.colors.fontcolor : Qt.rgba(Config.colors.fontcolor.r, Config.colors.fontcolor.g, Config.colors.fontcolor.b, 0.4)
                                    font.family: Config.font
                                    font.pixelSize: 12
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            }

                            MouseArea {
                                id: subItemHover
                                anchors.fill: parent
                                hoverEnabled: true
                                enabled: modelData.enabled

                                onClicked: {
                                    modelData.triggered();
                                    root.itemClicked();
                                }
                            }
                        }
                    }
                }
            }
            // Обновляем высоту делегата с учётом подменю
            height: (modelData.isSeparator ? 8 : 36) + (subMenu.visible ? subMenu.implicitHeight + 4 : 0)

            Behavior on height {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
}
