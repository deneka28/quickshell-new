pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Qt5Compat.GraphicalEffects

import "../../Shared"
import "../../Configs"

PopupWind {
    id: root
    implicitWidth: 410
    implicitHeight: 200

    property real currentPosition: 0

    ColumnLayout {
        Layout.fillWidth: true
        anchors {
            fill: parent
            margins: 20
        }
        spacing: 2
        Connections {
            target: item.player
            function onPlaybackStateChanged() {
                positionTimer.running = item.player?.isPlaying ?? false;
            }
        }
        Connections {
            target: item.player
            function onTrackChanged() {
                root.currentPosition = 0;
            }
            function onIsPlayingChanged() {
                if (item.player?.isPlaying) {
                    root.currentPosition = item.player.position;
                }
            }
        }

        Timer {
            id: positionTimer
            interval: 500
            repeat: true
            running: item.player?.isPlaying ?? false
            onTriggered: {
                if (item.player) {
                    item.player.positionChanged();
                    root.currentPosition = item.player.position;
                }
            }
        }
        // ... твой контент
        RowLayout {
            spacing: 60
            ColumnLayout {
                spacing: 10
                // Название трека — с анимацией прокрутки
                Item {
                    implicitWidth: 120
                    implicitHeight: 16
                    clip: true
                    Layout.alignment: Qt.AlignVCenter

                    StyledText {
                        id: trackName
                        styledText: {
                            const title = item.player?.trackTitle ?? "";
                            if (title)
                                return `${title}`;
                            return title || "";
                        }
                        color: Config.colors.fontcolor
                        fontSize: 16
                        opacity: item.player?.isPlaying ? 1.0 : 0.5

                        // Прокрутка если текст не влезает
                        x: trackName.implicitWidth > 120 ? scrollAnim.running ? x : 0 : 0

                        NumberAnimation {
                            id: scrollAnim
                            target: trackName
                            property: "x"
                            from: 0
                            to: -(trackName.implicitWidth + 20)
                            duration: trackName.implicitWidth * 60
                            loops: Animation.Infinite
                            running: trackName.implicitWidth > 120 && (item.player?.isPlaying ?? false)
                        }
                    }
                }
                Item {
                    implicitWidth: 120
                    implicitHeight: 16
                    clip: true
                    Layout.alignment: Qt.AlignVCenter

                    StyledText {
                        id: trackArtist
                        styledText: {
                            const artist = item.player?.trackArtist ?? "";
                            if (artist)
                                return `${artist}`;
                            return artist || "";
                        }
                        color: Config.colors.fontcolor
                        fontSize: 16
                        opacity: item.player?.isPlaying ? 1.0 : 0.5

                        // Прокрутка если текст не влезает
                        x: trackArtist.implicitWidth > 120 ? scrollAnim.running ? x : 0 : 0

                        NumberAnimation {
                            id: scrollAnimArt
                            target: trackArtist
                            property: "x"
                            from: 0
                            to: -(trackArtist.implicitWidth + 20)
                            duration: trackArtist.implicitWidth * 60
                            loops: Animation.Infinite
                            running: trackArtist.implicitWidth > 120 && (item.player?.isPlaying ?? false)
                        }
                    }
                }
                Item {
                    id: item
                    implicitWidth: visible ? row.implicitWidth : 0
                    implicitHeight: 36

                    property var player: {
                        for (const p of Mpris.players.values) {
                            if (p.isPlaying)
                                return p;
                        }
                        return Mpris.players.values[0] ?? null;
                    }

                    visible: item.player != null

                    Behavior on implicitWidth {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.InOutCubic
                        }
                    }

                    RowLayout {
                        id: row
                        anchors.centerIn: parent
                        spacing: 8

                        IconImage {
                            implicitWidth: 36
                            implicitHeight: 36

                            source: Quickshell.iconPath("media-skip-backward-symbolic")
                            opacity: item.player?.canGoPrevios ? 1.0 : 0.3
                            Layout.alignment: Qt.AlignVCenter

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                enabled: item.player?.canGoPrevios ?? false
                                onClicked: item.player?.previos()
                            }
                        }

                        IconImage {
                            implicitWidth: 36
                            implicitHeight: 36
                            source: item.player?.isPlaying ? Quickshell.iconPath("media-playback-pause-symbolic") : Quickshell.iconPath("media-playback-start-symbolic")
                            opacity: item.player?.canTogglePlaying ? 1.0 : 0.3
                            Layout.alignment: Qt.AlignVCenter

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                enabled: item.player?.canTogglePlaying ?? false
                                acceptedButtons: Qt.LeftButton
                                onClicked: item.player?.togglePlaying()
                            }
                        }

                        // Next
                        IconImage {
                            implicitWidth: 36
                            implicitHeight: 36
                            source: Quickshell.iconPath("media-skip-forward-symbolic")
                            opacity: item.player?.canGoNext ? 1.0 : 0.3
                            Layout.alignment: Qt.AlignVCenter

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                enabled: item.player?.canGoNext ?? false
                                onClicked: item.player?.next()
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: albomPic
                implicitWidth: 160
                implicitHeight: 160
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: albomPic.width
                        height: albomPic.height
                        radius: albomPic.radius
                    }
                }
                color: "transparent"
                radius: 80
                clip: false
                Image {
                    anchors.fill: parent
                    source: item.player?.trackArtUrl ?? ""
                    cache: true
                    opacity: 0.9
                    fillMode: Image.PreserveAspectCrop
                    visible: source !== ""
                }
                CircleProgress {
                    id: progressCircl
                    anchors.centerIn: parent
                    size: 161
                    lineWidth: 6
                    colorCircle: Config.colors.fontcolor
                    opacity: 0.5
                    colorBackground: Qt.rgba(Config.colors.fontcolor.r, Config.colors.fontcolor.g, Config.colors.fontcolor.b, 0.5)
                    showBackground: true
                    arcBegin: 0
                    arcOffset: 0
                    arcEnd: {
                        const pos = root.currentPosition;
                        const len = item.player?.length ?? 0;
                        return len > 0 ? 360 * (pos / len) : 0;
                    }
                }

                IconImage {
                    anchors.centerIn: parent
                    implicitWidth: 64
                    implicitHeight: 64
                    source: item.player?.isPlaying ? Quickshell.iconPath("media-playback-pause-symbolic") : Quickshell.iconPath("media-playback-start-symbolic")
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    enabled: item.player?.canTogglePlaying ?? false
                    acceptedButtons: Qt.LeftButton
                    onClicked: item.player?.togglePlaying()

                    onWheel: event => {
                        if (!item.player?.canSeek)
                            return;
                        const delta = (event.angleDelta.y / 120) * 5;
                        const newPos = Math.max(0, Math.min(item.player.length, item.player.position + delta));
                        item.player.position = newPos;
                        item.player.positionChanged();
                    }
                }
            }
        }
    }
    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.InOutCubic
        }
    }
}
