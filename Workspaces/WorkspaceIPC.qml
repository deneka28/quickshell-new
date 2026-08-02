import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.I3

Item {
    id: root

    property int active: 1 // currently active workspace
    property int amount: 10 // amount of workspaces
    property string name: "unknown" // name of the current desktop

    function switchWorkspace(w) {
        switch (root.name) {
        case "sway":
        case "none+i3":
            I3.dispatch(`workspace ${w}`);
            break;
        case "Hyprland":
            switchProcess.command = ["hyprctl", "eval", `hl.dispatch(hl.dsp.focus({ workspace = "${w}" }))`];
            switchProcess.running = true;
            break;
        default:
            console.log("unhandled");
        }
    }

    Process {
        id: switchProcess
        running: false
    }
    Component.onCompleted: {
        root.name = Quickshell.env("XDG_CURRENT_DESKTOP");

        switch (root.name) {
        case "sway":
        case "none+i3":
            root.active = Qt.binding(() => I3.focusedWorkspace?.num ?? root.active);
            break;
        case "Hyprland":
            root.active = Qt.binding(() => Hyprland.focusedMonitor?.activeWorkspace?.id ?? root.active);
            break;
        default:
            console.log("This desktop is unhandled:", root.name);
        }
    }
}
