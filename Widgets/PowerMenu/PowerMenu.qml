pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../../Shared"
import "../../Configs"
import "../../Services"

PopupPanel {
    id: root
    direction: "down"
    anchors {
        top: true
        left: true
    }
    margins {
        top: 4
        left: 4
    }
    implicitWidth: 200
    implicitHeight: contentCol.implicitHeight + 24

    property string pendingAction: ""

    function executePending() {
        switch (pendingAction) {
        case "shutdown":
            PowerService.shutdown();
            break;
        case "reboot":
            PowerService.reboot();
            break;
        }
        pendingAction = "";
        root.closeWithAnimation();
    }

    function cancel() {
        pendingAction = "";
    }

    ColumnLayout {
        id: contentCol
        anchors {
            fill: parent
            margins: 12
        }
        spacing: 4

        // Обычный режим
        ColumnLayout {
            visible: root.pendingAction === ""
            Layout.fillWidth: true
            spacing: 4

            PowerButton {
                Layout.fillWidth: true
                icon: "system-lock-screen-symbolic"
                label: "Заблокировать"
                btnColor: "#89b4fa"
                onTriggered: {
                    PowerService.lock();
                    root.closeWithAnimation();
                }
            }

            PowerButton {
                Layout.fillWidth: true
                icon: "weather-clear-night-symbolic"
                label: "Сон"
                btnColor: "#cba6f7"
                onTriggered: {
                    PowerService.suspend();
                    root.closeWithAnimation();
                }
            }

            PowerButton {
                Layout.fillWidth: true
                icon: "weather-clear-night-symbolic"
                label: "Гибернация"
                btnColor: "#b4befe"
                onTriggered: {
                    PowerService.hibernate();
                    root.closeWithAnimation();
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#ffffff"
                opacity: 0.08
            }

            PowerButton {
                Layout.fillWidth: true
                icon: "system-reboot-symbolic"
                label: "Перезагрузить"
                btnColor: "#f9e2af"
                onTriggered: root.pendingAction = "reboot"
            }

            PowerButton {
                Layout.fillWidth: true
                icon: "system-shutdown-symbolic"
                label: "Выключить"
                btnColor: "#f38ba8"
                onTriggered: root.pendingAction = "shutdown"
            }
        }

        // Режим подтверждения
        ColumnLayout {
            visible: root.pendingAction !== ""
            Layout.fillWidth: true
            spacing: 8

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: root.pendingAction === "shutdown" ? "Выключить компьютер?" : "Перезагрузить компьютер?"
                color: Config.colors.fontcolor
                font.family: Config.font
                font.pixelSize: 13
                font.bold: true
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // Отмена
                Rectangle {
                    Layout.fillWidth: true
                    height: 36
                    radius: 8
                    color: cancelHover.containsMouse ? "#45475a" : "#313244"

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Отмена"
                        color: Config.colors.fontcolor
                        font.family: Config.font
                        font.pixelSize: 13
                    }

                    MouseArea {
                        id: cancelHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.cancel()
                    }
                }

                // Подтверждение
                Rectangle {
                    Layout.fillWidth: true
                    height: 36
                    radius: 8
                    color: {
                        const base = root.pendingAction === "shutdown" ? "#f38ba8" : "#f9e2af";
                        const hover = root.pendingAction === "shutdown" ? "#c4596b" : "#c9a43a";
                        return confirmHover.containsMouse ? hover : base;
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Да"
                        color: "#1e1e2e"
                        font.family: Config.font
                        font.pixelSize: 13
                        font.bold: true
                    }

                    MouseArea {
                        id: confirmHover
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.executePending()
                    }
                }
            }
        }
    }
}
