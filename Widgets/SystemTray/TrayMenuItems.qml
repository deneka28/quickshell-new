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
            required property QsMenuEntry modelData
            Layout.fillWidth: true
            // implicitHeight: modelData.isSeparator ? 8 : 36
            height: modelData.isSeparator ? 8 : 36

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
                visible: !modelData.isSeparator
                anchors.fill: parent
                radius: 6
                color: itemHover.containsMouse ? Config.colors.controlscolor : "transparent"

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

                    // Иконка пункта меню
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
                }

                MouseArea {
                    id: itemHover
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
