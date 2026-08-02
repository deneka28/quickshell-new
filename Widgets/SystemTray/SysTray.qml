//@ pragma UseQApplication
import Quickshell.Services.SystemTray
import QtQuick

Item {
    id: root
    clip: true
    visible: width > 0 && height > 0
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    Row {
        id: layout
        spacing: 6

        add: Transition {
            NumberAnimation {
                properties: "scale"
                from: 0
                to: 1
                duration: 300
                easing.type: Easing.OutBack
            }
        }

        Repeater {
            model: SystemTray.items
            delegate: SysTrayItem {}
        }
    }
}
