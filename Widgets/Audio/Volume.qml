import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import "../../Shared"
import "../../Configs"

ColumnLayout {
    required property PwNode node
    visible: node !== null //&& node.isBound

    PwObjectTracker {
        objects: [node]
    }

    RowLayout {
        Image {
            visible: source !== ""
            source: {
                if (!node?.properties) {
                    return "";
                }
                const icon = node.properties["application.icon-name"] ?? "audio-volume-high-symbolic";
                return `image://icon/${icon}`;
            }
            sourceSize.width: 20
            sourceSize.height: 20
        }
        StyledText {
            styledText: {
                if (!node?.properties) {
                    return "";
                }
                const app = node.properties["application.name"] ?? (node.description != "" ? node.description : node.name);
                const media = node.properties["media.name"];
                return media != undefined ? `${app} - ${media}` : app;
            }
            fontSize: 12
        }

        CustomButton {
            label: node?.audio.muted ? " unmute" : " mute"
            btnColor: Config.colors.btncolor
            iconSource: node?.audio?.muted ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic"
            enabled: node?.audio !== null
            onClicked: {
                if (node?.audio) {
                    node.audio.muted = !node.audio.muted;
                }
                //node.audio.muted = !node.audio.muted
            }
        }
    }
    RowLayout {
        StyledText {
            Layout.preferredWidth: 50
            styledText: `${Math.floor(node?.audio.volume * 100)}%`
        }
        StyledSlider {
            Layout.fillWidth: true
            value: node?.audio.volume
            onValueChanged: node.audio.volume = value
        }
    }
}
