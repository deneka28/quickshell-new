pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import "../../Services"
import "../../Configs"
import "../../Shared"

PopupPanel {
    id: root
    direction: "down"
    anchors {
        top: true
        right: true
    }
    margins {
        top: 4
        right: 4
    }
    implicitWidth: 400
    implicitHeight: 500

    ColumnLayout {
        anchors {
            fill: parent
            margins: 10
        }
        spacing: 8

        // Заголовок
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Буфер обмена"
                font.pixelSize: 15
                font.bold: true
                font.family: Config.font
                color: Config.colors.fontcolor
                Layout.fillWidth: true
            }

            // Очистить
            Rectangle {
                implicitWidth: 28
                implicitHeight: 28
                radius: 6
                color: clearHover.containsMouse ? "#f38ba8" : Config.colors.controlscolor
                Behavior on color { ColorAnimation { duration: 100 } }

                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pixelSize: 12
                    color: clearHover.containsMouse ? "#1e1e2e" : Config.colors.fontcolor
                }

                MouseArea {
                    id: clearHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        ClipboardService.runningWipe = true
                        ClipboardService.runningCount = true
                    }
                }
            }
        }

        // Поиск
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 32
            radius: 6
            color: Config.colors.controlscolor
            border.width: searchInput.activeFocus ? 1 : 0
            border.color: "#89b4fa"

            Behavior on border.width { NumberAnimation { duration: 100 } }

            TextInput {
                id: searchInput
                anchors {
                    fill: parent
                    margins: 8
                }
                color: Config.colors.fontcolor
                font.pixelSize: 13
                font.family: Config.font
                clip: true

                Text {
                    visible: searchInput.text === ""
                    text: "Поиск..."
                    color: Config.colors.fontcolor
                    opacity: 0.4
                    font.pixelSize: 13
                    font.family: Config.font
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Список
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 4

            model: {
                const search = searchInput.text.toLowerCase()
                return ClipboardService.clipHistList.filter(line => {
                    if (!line || line.trim() === "") return false
                    const tab = line.indexOf('\t')
                    if (tab < 0) return false
                    const data = line.substring(tab + 1).trim()
                    if (search === "") return true
                    return data.toLowerCase().includes(search)
                })
            }

delegate: Rectangle {
    id: delegateItem
    required property var modelData
    required property int index

    width: listView.width
    radius: 8
    Component.onCompleted: {
        if (delegateItem.isBinary) {
            ClipboardService.decodeBinaryPreview(
                delegateItem.modelData,
                delegateItem.entryId)
        }
    }

    property int tabIdx: modelData.indexOf('\t')
    property string entryId: tabIdx > 0 ? modelData.substring(0, tabIdx).trim() : ""
    property string entryData: tabIdx > 0 ? modelData.substring(tabIdx + 1).trim() : modelData

    property string contentType: {
        if (entryData.startsWith("[[")) return "binary"
        if (entryData.match(/\.(jpg|jpeg|png|gif|webp)$/i)) return "image"
        return "text"
    }

    property bool isImage: contentType === "image"
    property bool isBinary: contentType === "binary"
    property bool hovered: itemHover.containsMouse

    height: isBinary ? 80 : 40
    color: hovered ? Config.colors.controlscolor : "transparent"
    Behavior on color { ColorAnimation { duration: 100 } }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: 8
            rightMargin: 8
        }
        spacing: 8
        Image {
            visible: delegateItem.isBinary
            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
            source: {
                const path = ClipboardService.binaryPreviews[delegateItem.entryId]
                return path ? "file://" + path : ""
            }
            fillMode: Image.PreserveAspectFit
            Layout.alignment: Qt.AlignVCenter
            cache: false

        // Пока загружается — иконка
            IconImage {
                visible: parent.status !== Image.Ready
                anchors.centerIn: parent
                implicitWidth: 20
                implicitHeight: 20
                source: Quickshell.iconPath("image-x-generic-symbolic")
            }
        }
        // // Превью изображения
        // Image {
        //     visible: delegateItem.isImage
        //     Layout.preferredWidth: 60
        //     Layout.preferredHeight: 60
        //     source: delegateItem.isImage
        //         ? decodeURIComponent(delegateItem.entryData.replace("file://", ""))
        //         : ""
        //     fillMode: Image.PreserveAspectFit
        //     Layout.alignment: Qt.AlignVCenter
        // }
        //
        // // Иконка бинарных данных из темы
        // IconImage {
        //     visible: delegateItem.isBinary
        //     Layout.preferredWidth: 20
        //     Layout.preferredHeight: 20
        //     source: Quickshell.iconPath("image-x-generic-symbolic")
        //     Layout.alignment: Qt.AlignVCenter
        // }
        //
        // Текст — центрирован по вертикали
        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            text: delegateItem.entryData
            color: Config.colors.fontcolor
            font.pixelSize: 12
            font.family: Config.font
            elide: Text.ElideRight
            maximumLineCount: delegateItem.isImage ? 1 : 2
            wrapMode: Text.Wrap
            opacity: delegateItem.isBinary ? 0.5 : 1.0
            verticalAlignment: Text.AlignVCenter
        }

        // Кнопка удалить — иконка из темы
        // Используем Item как контейнер чтобы избежать фриза
        Item {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignVCenter
            visible: delegateItem.hovered

            IconImage {
                id: deleteIcon
                anchors.centerIn: parent
                implicitWidth: 16
                implicitHeight: 16
                source: Quickshell.iconPath("edit-delete-symbolic")
                // Подсветка при наведении через opacity
                opacity: deleteHover.containsMouse ? 1.0 : 0.6
                Behavior on opacity { NumberAnimation { duration: 100 } }
            }

            MouseArea {
                id: deleteHover
                anchors.fill: parent
                hoverEnabled: true
                // Останавливаем propagation чтобы не триггерить itemHover
                propagateComposedEvents: false
                onClicked: {
                    ClipboardService.deleteEntry(delegateItem.modelData)
                }
            }
        }
    }

    // Основной MouseArea под контентом
    MouseArea {
        id: itemHover
        anchors.fill: parent
        hoverEnabled: true
        z: -1
        propagateComposedEvents: true
        onClicked: {
            ClipboardService.copyEntry(
                // delegateItem.entryId,
                delegateItem.modelData,
                delegateItem.contentType
            )
            root.closeWithAnimation()
        }
    }
}
            // Пусто
            Text {
                visible: listView.count === 0
                anchors.centerIn: parent
                text: searchInput.text !== "" ? "Ничего не найдено" : "История пуста"
                color: Config.colors.fontcolor
                opacity: 0.4
                font.pixelSize: 13
                font.family: Config.font
            }
        }
    }
}
