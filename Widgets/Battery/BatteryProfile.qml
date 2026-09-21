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
    implicitHeight: 250
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
                        const seconds = BatteryService.status === "Charging" ? BatteryService.timeToFull : BatteryService.timeToEmpty;

                        const hours = Math.floor(seconds / 3600);
                        const minutes = Math.floor((seconds % 3600) / 60);

                        const hh = String(hours).padStart(2, "0");
                        const mm = String(minutes).padStart(2, "0");

                        return `${BatteryService.status}    ${hh}ч ${mm}м`;
                    }
                    font.family: Config.font
                    font.pixelSize: 12
                    color: Config.colors.fontcolor
                    leftPadding: 20
                    opacity: 0.6
                }
                StyledText {
                    styledText: "Яркость экрана"
                    leftPadding: 20
                    fontSize: 24
                    Layout.topMargin: 20
                }
                RowLayout {
                    IconImage {
                        source: Quickshell.iconPath("display-brightness-symbolic")
                        implicitSize: 30
                        Layout.leftMargin: 20
                    }
                    StyledSlider {
                        id: slider
                        from: 1
                        to: 100

                        Layout.fillWidth: true
                        Layout.rightMargin: 10
                        Layout.leftMargin: 10
                        value: pressed ? value : Brightness.value
                        Timer {
                            id: updateTimer

                            interval: 30
                            repeat: false

                            onTriggered: {
                                Brightness.set(slider.value);
                            }
                        }
                        onMoved: {
                            updateTimer.restart();
                        }
                        Connections {
                            target: Brightness

                            function onChanged() {
                                if (!slider.pressed)
                                    slider.value = Brightness.value;
                            }
                        }
                    }
                    StyledText {
                        styledText: Brightness.value + "%"
                        // Layout.leftMargin: 20
                        Layout.rightMargin: 20
                    }
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
