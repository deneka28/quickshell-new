pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../Configs"
import "../Services"
import "../Shared"

PanelWindow {
    id: root

    anchors {
        top: true
        left: false
        right: false
    }
    margins {
        top: 30
    }

    implicitWidth: 420
    // Высота подстраивается под количество уведомлений
    implicitHeight: popupList.implicitHeight + 20

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    // Показываем только если есть активные попапы
    visible: NotifServer.popups.length > 0 && !NotifServer.dnd

    // Маска чтобы клики проходили сквозь пустые места
    mask: Region {
        item: popupList
    }

    ColumnLayout {
        id: popupList
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
        }
        width: root.implicitWidth - 20
        spacing: 8

        Repeater {
            model: NotifServer.popups
            delegate: NotificationPopupItem {
                required property var modelData
                Layout.fillWidth: true
                notif: modelData
            }
        }
    }
}
