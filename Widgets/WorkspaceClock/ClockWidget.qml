//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import "../../Configs"
import "../../Services"

Item {
    id: root
    property int size: clocWidget.width
    PanelWindow {
        id: bar
        implicitWidth: clocWidgetDate.width
        implicitHeight: clocWidget.height + clocWidgetDate.height + timeWidget.height
        color: "transparent"
        exclusiveZone: 0

        WlrLayershell.layer: WlrLayer.Bottom
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        anchors {
            top: true
            bottom: false
            left: true
            right: false
        }
        margins {
            top: 100
            right: 100
            left: 100
        }
        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: clocWidgetDate
                Layout.fillWidth: true
                text: qsTr(Time.format("dddd")).toUpperCase()
                font.pointSize: 100
                font.bold: true
                font.family: "Anurati"
                color: WallpaperService.accentColor
                horizontalAlignment: Text.AlignHCenter

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#000000"
                    shadowOpacity: 0.8
                    shadowBlur: 0.4
                    shadowHorizontalOffset: 3
                    shadowVerticalOffset: 3
                }
            }
            Text {
                id: clocWidget
                Layout.fillWidth: true
                text: qsTr(Time.format("dd MMMM yyyy")).toUpperCase()
                font.pointSize: 30
                font.bold: true
                font.family: "Poppin"
                color: WallpaperService.dateTimeColor
                horizontalAlignment: Text.AlignHCenter

                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#000000"
                    shadowOpacity: 0.8
                    shadowBlur: 0.4
                    shadowHorizontalOffset: 3
                    shadowVerticalOffset: 3
                }
            }
            Text {
                id: timeWidget
                Layout.fillWidth: true
                text: qsTr(Time.format("- hh:mm:ss -"))
                font.pointSize: 25
                // font.bold: true
                font.family: "Poppin"
                color: WallpaperService.dateTimeColor
                horizontalAlignment: Text.AlignHCenter
                layer.enabled: true
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#000000"
                    shadowOpacity: 0.8
                    shadowBlur: 0.5
                    shadowHorizontalOffset: 3
                    shadowVerticalOffset: 3
                }
            }
        }
    }
}
