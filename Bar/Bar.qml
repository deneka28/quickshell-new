//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import QtQuick.Effects

import "../Configs"
import "../Shared"
import "../Workspaces"
import "../Clock"
import "../Widgets/Audio"
import "../Widgets/Battery"
import "../Widgets/SystemTray"
import "../Widgets/KbLayout"
import "../Widgets/Wallpaper"
import "../Widgets/Screenshot"
import "../Widgets/Clipboard"

Item {
    id: root
    property int size: 34
    WlrLayershell {
        id: barShadow
        implicitHeight: bar.height + 50
        color: "transparent"
        layer: WlrLayer.Bottom
        exclusionMode: ExclusionMode.Ignore
        anchors: bar.anchors

        Rectangle {
            color: barContent.color
            anchors {
                top: parent.top
            }
            height: barContent.height
            width: parent.width + 40

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                // The vertical offset makes the shadow slightly more prominent
                shadowVerticalOffset: 10
                shadowHorizontalOffset: -20
                shadowBlur: 0.85
                blurMultiplier: 0.85
                shadowColor: "#000000"
            }
        }
    }
    PanelWindow {
        id: bar
        implicitHeight: root.size
        color: Config.colors.widgetcolor
        anchors {
            top: true
            bottom: false
            left: true
            right: true
        }
        margins {
            top: 3
            right: 0
            left: 0
        }
        Rectangle {
            id: barContent
            anchors.fill: parent

            color: Config.colors.widgetcolor
            RowLayout {
                id: leftPlase
                spacing: 4
                anchors {
                    left: parent.left
                    leftMargin: 6
                    verticalCenter: parent.verticalCenter
                }
                BarItem {
                    color: "transparent"
                    PowerButton {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                BarItem {
                    implicitHeight: 24
                    radius: 12
                    Workspaces {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                BarItem {
                    color: "transparent"
                    CurrentWindow {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
            RowLayout {
                id: centerPlase
                spacing: 4
                anchors {
                    centerIn: parent
                    verticalCenter: parent.verticalCenter
                }
                BarItem {
                    Layout.alignment: Qt.AlignVCenter
                    implicitHeight: 24
                    radius: 12
                    color: "transparent"
                    Clock {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
            RowLayout {
                id: rightPlase
                spacing: 4
                anchors {
                    right: parent.right
                    rightMargin: 6
                    verticalCenter: parent.verticalCenter
                }
                ItemHideShow {
                    color: "transparent"
                    WallpaperBarButton {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ScreenShotButton {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    ClipboardButton {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                BarItem {
                    color: "transparent"
                    KbLayout {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    SysTray {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    VolumeButton {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    BatteryRadial {
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }
}
