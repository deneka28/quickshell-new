import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../Services"
import "../Configs"
import "../Notifications"
import "../Shared"

Item {
    id: root
    implicitWidth: row.implicitWidth
    implicitHeight: 14

    HyprlandFocusGrab {
        id: grab
        windows: [centralPanel]
        onCleared: centralPanel.closeWithAnimation()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        // DND иконка
        Text {
            text: NotifServer.dnd ? "󰂛" : "󰂚"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
            color: NotifServer.dnd ? "#f38ba8" : Config.colors.fontcolor
            opacity: NotifServer.dnd ? 1.0 : 0.5

            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: NotifServer.toggleDnd()
            }
        }

        // Часы
        Text {
            text: Time.format("hh:mm    dd.MM.yyyy")
            font.family: Config.font
            color: Config.colors.fontcolor
            font.pixelSize: 14
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (centralPanel.shouldShow) {
                centralPanel.closeWithAnimation();
                grab.active = false;
            } else {
                grab.active = true;
                centralPanel.show();
            }
        }
    }

    CentralPanel {
        id: centralPanel
    }
}
