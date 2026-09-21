pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Services.Mpris

import "../../Configs"

Item {
    id: root

    implicitWidth: visible ? row.implicitWidth : 0
    implicitHeight: 24

    property var player: {
        for (const p of Mpris.players.values) {
            if (p.isPlaying)
                return p;
        }
        return Mpris.players.values[0] ?? null;
    }

    visible: root.player != null

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4

        IconImage {
            implicitWidth: 24
            implicitHeight: 24

            source: Quickshell.iconPath("media-skip-backward-symbolic")
            opacity: root.player?.canGoPrevios ? 1.0 : 0.3
            Layout.alignment: Qt.AlignVCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                enabled: root.player?.canGoPrevios ?? false
                onClicked: root.player?.previos()
            }
        }

        IconImage {
            implicitWidth: 24
            implicitHeight: 24
            source: root.player?.isPlaying ? Quickshell.iconPath("media-playback-pause-symbolic") : Quickshell.iconPath("media-playback-start-symbolic")
            opacity: root.player?.canTogglePlaying ? 1.0 : 0.3
            Layout.alignment: Qt.AlignVCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                enabled: root.player?.canTogglePlaying ?? false
                onClicked: root.player?.togglePlaying()
            }
        }

        // Next
        IconImage {
            implicitWidth: 24
            implicitHeight: 24
            source: Quickshell.iconPath("media-skip-forward-symbolic")
            opacity: root.player?.canGoNext ? 1.0 : 0.3
            scale: mouseNext.containsMouse ? 1.1 : 1.0
            Layout.alignment: Qt.AlignVCenter
            Behavior on scale {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutBack
                }
            }

            MouseArea {
                id: mouseNext
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                enabled: root.player?.canGoNext ?? false
                onClicked: root.player?.next()
            }
        }
        // Разделитель
        Rectangle {
            implicitWidth: 1
            implicitHeight: 14
            color: Config.colors.fontcolor
            opacity: 0.2
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: 10
            Layout.rightMargin: 10
        }
        // Название трека — с анимацией прокрутки
        Item {
            implicitWidth: 120
            implicitHeight: 16
            clip: true
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: trackText
                text: {
                    const title = root.player?.trackTitle ?? "";
                    const artist = root.player?.trackArtist ?? "";
                    if (title && artist)
                        return `${artist} — ${title}`;
                    return title || artist || "";
                }
                color: Config.colors.fontcolor
                font.pixelSize: 12
                font.family: Config.font
                opacity: root.player?.isPlaying ? 1.0 : 0.5

                // Прокрутка если текст не влезает
                x: trackText.implicitWidth > 120 ? scrollAnim.running ? x : 0 : 0

                NumberAnimation {
                    id: scrollAnim
                    target: trackText
                    property: "x"
                    from: 0
                    to: -(trackText.implicitWidth + 20)
                    duration: trackText.implicitWidth * 60
                    loops: Animation.Infinite
                    running: trackText.implicitWidth > 120 && (root.player?.isPlaying ?? false)
                }
            }
            HyprlandFocusGrab {
                id: grab
                windows: [mediaPanel]
                onCleared: mediaPanel.closeWithAnimation()
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (mediaPanel.shouldShow) {
                        mediaPanel.closeWithAnimation();
                        grab.active = false;
                    } else {
                        grab.active = true;
                        mediaPanel.show();
                    }
                }
            }
        }
    }
    MediaPanel {
        id: mediaPanel
        anchorItem: root
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
        }
    }
}
