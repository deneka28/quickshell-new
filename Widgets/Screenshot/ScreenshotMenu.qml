import QtQuick
import Quickshell
import Quickshell.Io

import "../../Shared"
import "../../Configs"

// import "../../Scripts"

PopupPanel {
    id: slidingPopup

    direction: "down"
    anchors {
        top: true
        left: false
        right: true
    }
    margins {
        top: 4
        right: 50
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
        width: 250
        height: 220

        Process {
            id: screenshotArea
            running: false
            command: ["hyprctl", "eval", "hl.dispatch(hl.dsp.exec_cmd('grim -g \"$(slurp)\" - | wl-copy'))"]
            onExited: code => console.log("[screenshot] exited:", code)
        }

        Process {
            id: screenshotWindow
            running: false
            command: ["hyprctl", "eval", "hl.dispatch(hl.dsp.exec_cmd('/home/alex/.config/quickshell/Scripts/screenshot-window.sh'))"]
            onExited: code => console.log("[screenshot window] exited:", code)
        }

        Process {
            id: screenshotFull
            running: false
            command: ["hyprctl", "eval", "hl.dispatch(hl.dsp.exec_cmd('grim - | wl-copy'))"]
        }

        Process {
            id: screenshotAreaSave
            running: false
            command: ["hyprctl", "eval", "hl.dispatch(hl.dsp.exec_cmd('grim -g \"$(slurp)\" ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png'))"]
        }

        Process {
            id: screenshotFullSave

            running: false
            command: ["sh", "-c", "grim ~/Pictures/Screenshots/screenshot-$(date +%Y%m%d-%H%M%S).png"]
            onExited: (code, status) => {
                console.log("Save full exited:", code.toString());
            }
        }
        // Таймеры для задержки запуска
        Timer {
            id: windowSaveTimer

            interval: 300
            onTriggered: {
                console.log("Starting area screenshot...");
                screenshotFullSave.running = true;
            }
        }

        Timer {
            id: windowTimer

            interval: 300
            onTriggered: {
                console.log("Starting window screenshot...");
                screenshotWindow.running = true;
            }
        }

        Timer {
            id: areaSaveTimer

            interval: 200
            onTriggered: {
                console.log("Starting save area screenshot...");
                screenshotAreaSave.running = true;
            }
        }
        Timer {
            id: areaTimer
            interval: 500  // даём время панели закрыться
            onTriggered: screenshotArea.running = true
        }
        Column {
            id: contentColumn

            anchors.fill: parent
            anchors.margins: 10
            spacing: 5

            Text {
                width: parent.width
                text: "Скриншот"
                font.pixelSize: 16
                font.bold: true
                color: Config.colors.fontcolor
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#ffffff"
                opacity: 0.08
            }
            CustomButton {
                iconSource: "screenshot-area-symbolic"
                label: "Выбрать область"
                btnColor: "#8a8a8a"
                onClicked: {
                    slidingPopup.closeWithAnimation();
                    screenshotArea.running = true;
                }
            }

            CustomButton {
                iconSource: "screenshot-window-symbolic"
                label: "Текущее окно"
                btnColor: "#8a8a8a"
                onClicked: {
                    slidingPopup.closeWithAnimation();
                    windowTimer.start();
                }
            }
            CustomButton {
                iconSource: "screenshot-fullscreen-symbolic"
                label: "Весь экран"
                btnColor: "#8a8a8a"
                onClicked: {
                    slidingPopup.closeWithAnimation();
                    screenshotFull.running = true;
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: "#ffffff"
                opacity: 0.08
            }
            CustomButton {
                iconSource: "document-save"
                label: "Сохранить область"
                btnColor: "#8a8a8a"
                onClicked: {
                    slidingPopup.closeWithAnimation();
                    areaSaveTimer.start();
                }
            }

            CustomButton {
                iconSource: "document-save"
                label: "Сохранить экран"
                btnColor: "#8a8a8a"
                onClicked: {
                    slidingPopup.closeWithAnimation();
                    windowSaveTimer.start();
                }
            }
        }
    }
}
