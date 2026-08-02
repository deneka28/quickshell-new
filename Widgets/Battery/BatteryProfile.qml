pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
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
        top: 4
        right: 4
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
        width: 400
        height: 200

        RowLayout {
            id: layout
            anchors.centerIn: parent
            spacing: 4
            Text {
                id: head

                text: qsTr("Питание и подсветка")
                font: Config.font
            }
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
