import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "../../Services"
import "../../Shared"
import "../../Configs"

PopupPanel {
    id: devicePopup

    property bool open: false

    direction: "down"
    implicitWidth: 400
    implicitHeight: Math.min(deviceList.contentHeight + 70, 500)
    color: "transparent"

    anchors {
        right: true
        top: true
    }
    margins {
        right: 50
    }

    contentItem: Rectangle {
        anchors.fill: parent
        color: "transparent"
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Заголовок
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Накопители"
                    font.pixelSize: 16
                    font.bold: true
                    color: Config.colors.fontcolor
                    Layout.fillWidth: true
                }

                Text {
                    text: Devices.devices.length + " устр."
                    font.pixelSize: 12
                    color: Config.colors.fontcolor
                    opacity: 0.6
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 1
                color: "#ffffff"
                opacity: 0.08
            }

            // Пусто
            Text {
                visible: Devices.devices.length === 0
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Нет подключённых накопителей"
                color: Config.colors.fontcolor
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            // Список устройств
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: Devices.devices.length > 0
                clip: true

                ListView {
                    id: deviceList

                    spacing: 5
                    model: Devices.devices

                    delegate: Rectangle {
                        width: deviceList.width
                        height: contentRow.implicitHeight + 20
                        color: mouseArea.containsMouse ? Config.colors.widgetcolormidle : "transparent"
                        radius: 6

                        RowLayout {
                            id: contentRow

                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 12

                            // Иконка устройства
                            Item {
                                Layout.preferredHeight: 32
                                Layout.preferredWidth: 32
                                IconImage {
                                    implicitWidth: parent.width
                                    implicitHeight: parent.height
                                    source: Quickshell.iconPath("drive-removable-media-usb-symbolic")
                                }
                                Rectangle {
                                    implicitHeight: 12
                                    implicitWidth: 12
                                    radius: 6
                                    anchors.bottom: parent.bottom
                                    anchors.right: parent.right
                                    color: "orange"
                                    visible: modelData.isMounted ? false : true
                                }
                            }

                            // Информация
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 3

                                // Название и размер
                                RowLayout {
                                    Layout.fillWidth: true

                                    Text {
                                        text: modelData.label !== "" ? modelData.label : modelData.name
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: Config.colors.fontcolor
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        // Переводим байты в читаемый формат
                                        text: {
                                            let size = parseInt(modelData.size);
                                            if (size >= 1.07374e+09)
                                                return (size / 1.07374e+09).toFixed(1) + " GB";

                                            if (size >= 1.04858e+06)
                                                return (size / 1.04858e+06).toFixed(1) + " MB";

                                            return (size / 1024).toFixed(1) + " KB";
                                        }
                                        font.pixelSize: 11
                                        color: Config.colors.fontcolor
                                        opacity: 0.6
                                    }
                                }

                                // Информация о файловой системе и точке монтирования
                                Text {
                                    text: {
                                        let info = modelData.fstype;
                                        if (modelData.isMounted)
                                            info += " • " + modelData.mountpoint;

                                        return info;
                                    }
                                    font.pixelSize: 11
                                    color: Config.colors.fontcolor
                                    opacity: 0.7
                                }
                            }

                            // Кнопка монтирования / размонтирования
                            CustomButton {
                                Layout.preferredWidth: label.length + iconSource.width
                                Layout.preferredHeight: 26
                                btnColor: "#8a8a8a"
                                iconSource: modelData.isMounted ? "media-eject-symbolic" : "media-mount-symbolic"
                                label: modelData.isMounted ? "unplug" : "plug"
                                onClicked: {
                                    if (modelData.isMounted)
                                        Devices.umount(modelData.device);
                                    else
                                        Devices.mount(modelData.device);
                                }
                            }
                        }
                        MouseArea {
                            id: mouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            z: -1
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }
                }
            }
        }
    }
}
