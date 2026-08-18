//@ pragma UseQApplicatioimplicitHeightma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../Configs"

ColumnLayout {
    id: root
    required property QsMenuHandle menu
    signal itemClicked

    spacing: 2

    QsMenuOpener {
        id: menuOpener
        menu: root.menu
    }

    Repeater {
        model: menuOpener.children
        delegate: ColumnLayout {
            id: delegateItem
            required property QsMenuEntry modelData
            Layout.fillWidth: true
            spacing: 2

            QsMenuOpener {
                id: subMenuOpener
                menu: delegateItem.modelData.hasChildren ? delegateItem.modelData : null
            }

            // Разделитель
            Rectangle {
                visible: delegateItem.modelData.isSeparator
                Layout.fillWidth: true
                implicitHeight: 1
                color: Config.colors.fontcolor
                opacity: 0.1
                Layout.topMargin: 3
                Layout.bottomMargin: 3
            }

            // Пункт меню
            Rectangle {
                id: menuItemRect
                visible: !delegateItem.modelData.isSeparator
                Layout.fillWidth: true
                implicitHeight: 36
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
                        visible: delegateItem.modelData.icon?.toString() !== ""
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        source: delegateItem.modelData.icon ?? ""
                        sourceSize.width: 16
                        sourceSize.height: 16
                    }

                    Text {
                        text: delegateItem.modelData.text ?? ""
                        color: delegateItem.modelData.enabled ? Config.colors.fontcolor : Qt.rgba(Config.colors.fontcolor.r, Config.colors.fontcolor.g, Config.colors.fontcolor.b, 0.4)
                        font.family: Config.font
                        font.pixelSize: 13
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                    }

                    Text {
                        visible: delegateItem.modelData.checkState !== Qt.Unchecked
                        text: "✓"
                        color: Config.colors.fontcolor
                        font.pixelSize: 13
                        opacity: 0.7
                    }

                    Text {
                        visible: delegateItem.modelData.hasChildren
                        text: "›"
                        color: Config.colors.fontcolor
                        font.pixelSize: 16
                        opacity: 0.6
                        rotation: subMenu.expanded ? 90 : 0
                        Behavior on rotation {
                            NumberAnimation {
                                duration: 350
                                easing.type: Easing.InOutExpo
                            }
                        }
                    }
                }

                MouseArea {
                    id: itemHover
                    anchors.fill: parent
                    hoverEnabled: true
                    enabled: delegateItem.modelData.enabled
                    onClicked: {
                        if (delegateItem.modelData.hasChildren) {
                            subMenu.expanded = !subMenu.expanded;
                        } else {
                            delegateItem.modelData.triggered();
                            root.itemClicked();
                        }
                    }
                }
            }

            // Подменю — внутри того же ColumnLayout делегата
            ColumnLayout {
                id: subMenu
                Layout.fillWidth: true
                Layout.leftMargin: 12
                spacing: 2

                property bool expanded: false
                visible: expanded || fadeAnim.running

                opacity: expanded ? 1.0 : 0.0
                scale: expanded ? 1.0 : 0.95
                transformOrigin: Item.Top

                Behavior on opacity {
                    NumberAnimation {
                        id: fadeAnim
                        duration: 400
                        easing.type: Easing.InOutExpo
                    }
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: 400
                        easing.type: Easing.InOutExpo
                    }
                }

                Repeater {
                    model: subMenuOpener.children
                    delegate: ColumnLayout {
                        id: subDelegateItem
                        required property QsMenuEntry modelData
                        Layout.fillWidth: true
                        spacing: 0

                        Rectangle {
                            visible: subDelegateItem.modelData.isSeparator
                            Layout.fillWidth: true
                            implicitHeight: 1
                            color: Config.colors.fontcolor
                            opacity: 0.1
                            Layout.topMargin: 3
                            Layout.bottomMargin: 3
                        }

                        Rectangle {
                            visible: !subDelegateItem.modelData.isSeparator
                            Layout.fillWidth: true
                            implicitHeight: 32
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
                                    visible: subDelegateItem.modelData.icon?.toString() !== ""
                                    Layout.preferredWidth: 14
                                    Layout.preferredHeight: 14
                                    source: subDelegateItem.modelData.icon ?? ""
                                    sourceSize.width: 14
                                    sourceSize.height: 14
                                }

                                Text {
                                    text: subDelegateItem.modelData.text ?? ""
                                    color: subDelegateItem.modelData.enabled ? Config.colors.fontcolor : Qt.rgba(Config.colors.fontcolor.r, Config.colors.fontcolor.g, Config.colors.fontcolor.b, 0.4)
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
                                enabled: subDelegateItem.modelData.enabled
                                onClicked: {
                                    subDelegateItem.modelData.triggered();
                                    root.itemClicked();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
