import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

import "../../Services"

Item {
    id: root
    implicitWidth: 24
    implicitHeight: 24
    visible: Devices.devices.length > 0

    Connections {
        target: Devices

        function onMounted(device) {
            let name = Devices.getDeviceName(device);
            NotifServer.notify("Mounted", name + " Ok", 3000);
        }
        function onUnmounted(device) {
            let name = Devices.getDeviceName(device);
            NotifServer.notify("Unmounted", name + " Ok", 3000);
        }
        function onMountError(error) {
            NotifServer.notify("Error", error, 5000);
        }
    }

    HyprlandFocusGrab {
        id: grab
        windows: [devicesMenu]
        onCleared: devicesMenu.closeWithAnimation()
    }

    IconImage {
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 18
        implicitHeight: 18
        source: Quickshell.iconPath("drive-removable-media-symbolic")
    }

    Rectangle {
        visible: Devices.devices.some(d => !d.isMounted)
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: -2
        anchors.topMargin: -2
        implicitHeight: 16
        implicitWidth: 16
        radius: 8
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: Devices.devices.filter(d => !d.isMounted).length
            color: "#ffffff"
            font.pixelSize: 9
            font.bold: true
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            grab.active = true;
            devicesMenu.show();
        }
    }

    DevicesMenu {
        id: devicesMenu
    }
}
