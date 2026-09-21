pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../Configs"

Rectangle {
    id: root

    property int workspaceId: 1
    signal activated

    property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === workspaceId
    property var windows: ToplevelManager.toplevels.values.filter(t => t.activated !== undefined && t.workspace === workspaceId)

    width: 280
    height: 180
    radius: 12
    color: isActive ? "#40ffffff" : "#20ffffff"
    border.width: isActive ? 2 : 1
    border.color: isActive ? "#89b4fa" : "#40ffffff"

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    // Номер воркспейса
    Text {
        anchors {
            top: parent.top
            left: parent.left
            margins: 8
        }
        text: root.workspaceId
        color: "#ffffff"
        font.pixelSize: 12
        font.bold: root.isActive
        opacity: 0.7
    }

    // Миниатюры окон
    Item {
        anchors {
            fill: parent
            margins: 8
            topMargin: 24
        }
        clip: true

        Repeater {
            model: root.windows

            delegate: Item {
                id: windowItem
                required property var modelData

                // Масштабируем позицию окна в пространство превью
                property real scaleX: parent.width / (Quickshell.screens[0]?.width ?? 1920)
                property real scaleY: parent.height / (Quickshell.screens[0]?.height ?? 1080)

                x: (modelData.position?.x ?? 0) * scaleX
                y: (modelData.position?.y ?? 0) * scaleY
                width: Math.max((modelData.size?.width ?? 200) * scaleX, 40)
                height: Math.max((modelData.size?.height ?? 150) * scaleY, 30)

                // Превью окна через ScreencopyView
                ScreencopyView {
                    anchors.fill: parent
                    captureSource: windowItem.modelData
                    live: true
                    layer.enabled: true

                    // Ждём пока captureSource привяжется
                    onCaptureSourceChanged: {
                        if (captureSource !== null) {
                            captureFrame();
                        }
                    }

                    // И при появлении контента
                    onHasContentChanged: {
                        if (!hasContent)
                            captureFrame();
                    }

                    // Загружаем кадр когда превью готов
                    Component.onCompleted: captureFrame()
                }

                // Рамка
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    border.width: 1
                    border.color: "#40ffffff"
                    radius: 3
                }

                // Название окна
                Rectangle {
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    height: 16
                    color: "#80000000"
                    radius: 3

                    Text {
                        anchors {
                            fill: parent
                            leftMargin: 3
                        }
                        text: windowItem.modelData.title ?? ""
                        color: "#ffffff"
                        font.pixelSize: 8
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        windowItem.modelData.activate();
                        root.activated();
                    }
                }
            }
        }

        // Если пустой воркспейс
        Text {
            visible: root.windows.length === 0
            anchors.centerIn: parent
            text: "Пусто"
            color: "#40ffffff"
            font.pixelSize: 11
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: root.activated()
    }
}
