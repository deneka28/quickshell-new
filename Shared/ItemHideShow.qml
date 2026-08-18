import QtQuick
import QtQuick.Layouts
import "../Configs"

Rectangle {
    id: root
    default property alias content: layout.data
    color: Config.colors.controlscolor
    radius: 8
    clip: true

    property bool collapsible: layout.children.length > 1
    property bool collapsed: collapsible && !hoverArea.containsMouse

    implicitHeight: layout.implicitHeight + 8
    implicitWidth: collapsed ? (layout.children.length > 0 ? layout.children[0].implicitWidth + 16 : 32) : layout.implicitWidth + 16

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 250
            easing.type: Easing.InOutCubic
        }
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6
    }

    // Скрываем/показываем элементы начиная со второго
    onCollapsedChanged: {
        for (let i = 1; i < layout.children.length; i++) {
            layout.children[i].visible = !collapsed;
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true
        onClicked: mouse => mouse.accepted = false
        onPressed: mouse => mouse.accepted = false
        onReleased: mouse => mouse.accepted = false
        onWheel: wheel => wheel.accepted = false
    }

    Component.onCompleted: {
        // Инициализируем состояние
        for (let i = 1; i < layout.children.length; i++) {
            layout.children[i].visible = !collapsed;
        }
    }
}
