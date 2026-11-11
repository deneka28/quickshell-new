// Central config file
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    readonly property string stateDir: Quickshell.env("HOME") + "/.local/state/quickshell/"
    readonly property string statePath: stateDir + "alexshell.json"

    readonly property bool ready: stateFile.loaded

    property alias wallpaperAutoSwitch: adapter.wallpaperAutoSwitch
    property alias notifDnd: adapter.notifDnd
    property string name: "alex"
    property Colors colors: Colors {}
    // default font
    property font font: Qt.font({
        "family": "SF Pro Display"
    })
    property var keyboardLayouts: [
        {
            "code": "us",
            "label": "English (US)",
            "color": "dadada",
            "default": true
        },
        {
            "code": "ru",
            "label": "Russian",
            "color": "dadada",
            "default": false
        }
    ]

    Process {
        id: ensureStateDir
        command: ["mkdir", "-p", root.stateDir]
        running: true

        onExited: (exitCode, exitStatus) => {
            console.log("mkdir exited with code:", exitCode, "for dir:", root.stateDir);
            stateFile.path = root.statePath;
        }
    }

    Component.onCompleted: () => {
        console.log("Hello, " + root.name + "!");
    }

    component Colors: QtObject {
        // surface colors
        property string fontcolor: '#dadada'
        property string darckfontcolor: '#9f9f9f'
        property string widgetcolor: '#3b454b'
        property string btncolor: '#7f7f7f'
        property string btncolorActive: '#484848'
        property string widgetcolorhard: '#363636'
        property string controlscolor: '#806a6a6a'
        property string bgcolor: '#7a7c7d'
        property string shadow: "#000000"
        property string red900: "#ff0000"
        property string indicatorcolor: "#069dcf"
        property string borderolor: "#069dcf"
    }

    FileView {
        id: stateFile

        path: ""

        watchChanges: true
        onFileChanged: reload()
        onLoadFailed: error => writeAdapter()
        onAdapterUpdated: writeAdapter()

        adapter: JsonAdapter {
            id: adapter

            property bool wallpaperAutoSwitch: false
            property bool notifDnd: false
        }
    }
}
