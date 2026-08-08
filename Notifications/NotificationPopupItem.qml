pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import "../Configs"
import "../Services"
import "../Shared"

Rectangle {
    id: root

    required property var notif

    implicitHeight: content.implicitHeight + 20
    radius: 12
    color: itemHover.containsMouse ? Config.colors.widgetcolormidle : Config.colors.widgetcolor

    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.06)

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    // Анимация появления
    opacity: 0
    y: -20

    Component.onCompleted: {
        appearAnim.start();
    }

    SequentialAnimation {
        id: appearAnim
        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "opacity"
                to: 1
                duration: 250
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: root
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.OutBack
            }
        }
    }

    // Анимация исчезновения при popup = false
    Connections {
        target: root.notif
        function onPopupChanged() {
            if (!root.notif.popup) {
                disappearAnim.start();
            }
        }
    }

    SequentialAnimation {
        id: disappearAnim
        ParallelAnimation {
            NumberAnimation {
                target: root
                property: "opacity"
                to: 0
                duration: 200
                easing.type: Easing.InQuad
            }
            NumberAnimation {
                target: root
                property: "y"
                to: -20
                duration: 200
                easing.type: Easing.InQuad
            }
        }
    }

    RowLayout {
        id: content
        anchors {
            fill: parent
            margins: 12
        }
        spacing: 10

        // Иконка приложения
        Rectangle {
            implicitWidth: 42
            implicitHeight: 42
            radius: 12
            color: "transparent"
            clip: true

            Image {
                anchors.fill: parent
                source: root.notif.image || root.notif.appIcon
                fillMode: Image.PreserveAspectCrop
                smooth: true
            }
        }

        // Контент
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: root.notif.summary ?? ""
                    font.bold: true
                    font.pixelSize: 13
                    font.family: Config.font
                    color: Config.colors.fontcolor
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                // Таймер — убывающая полоска
                Item {
                    implicitWidth: 32
                    implicitHeight: 4
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        radius: 2
                        color: Config.colors.controlscolor
                    }

                    Rectangle {
                        id: timerBar
                        height: parent.height
                        radius: 2
                        width: parent.width
                        color: {
                            const urgency = root.notif.urgency;
                            if (urgency === 2)
                                return "#f38ba8";
                            if (urgency === 1)
                                return "#f9e2af";
                            return "#89b4fa";
                        }

                        NumberAnimation on width {
                            running: true
                            from: 32  // явное значение вместо parent.parent.width
                            to: 0
                            duration: root.notif.notification?.expireTimeout > 0 ? root.notif.notification.expireTimeout : 5000
                            easing.type: Easing.Linear
                        }
                    }
                }
            }

            Text {
                visible: root.notif.body !== ""
                text: root.notif.body ?? ""
                font.pixelSize: 12
                font.family: Config.font
                color: Config.colors.fontcolor
                opacity: 0.75
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                maximumLineCount: 3
                elide: Text.ElideRight
            }

            // Кнопки действий
            RowLayout {
                visible: root.notif.actions.length > 1
                Layout.fillWidth: true
                spacing: 6

                Repeater {
                    model: root.notif.actions
                    delegate: Rectangle {
                        required property var modelData
                        height: 26
                        implicitWidth: actionText.implicitWidth + 16
                        radius: 6
                        color: actionHover.containsMouse ? "#89b4fa" : Config.colors.controlscolor

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }

                        Text {
                            id: actionText
                            anchors.centerIn: parent
                            text: modelData.text ?? ""
                            font.pixelSize: 11
                            font.family: Config.font
                            color: actionHover.containsMouse ? "#1e1e2e" : Config.colors.fontcolor
                        }

                        MouseArea {
                            id: actionHover
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                modelData.invoke();
                                root.notif.popup = false;
                            }
                        }
                    }
                }
            }
        }

        // Кнопка закрыть
        Rectangle {
            implicitWidth: 22
            implicitHeight: 22
            radius: 6
            color: closeHover.containsMouse ? "#f38ba8" : "transparent"
            Behavior on color {
                ColorAnimation {
                    duration: 100
                }
            }
            Layout.alignment: Qt.AlignTop

            Text {
                anchors.centerIn: parent
                text: "✕"
                font.pixelSize: 10
                color: closeHover.containsMouse ? "#1e1e2e" : Config.colors.fontcolor
                opacity: closeHover.containsMouse ? 1 : 0.4
            }

            MouseArea {
                id: closeHover
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.notif.popup = false
            }
        }
    }

    MouseArea {
        id: itemHover
        anchors.fill: parent
        hoverEnabled: true
        z: -1
        onClicked: root.notif.popup = false
    }
}
