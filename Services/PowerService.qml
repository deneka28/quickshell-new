pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    function shutdown() {
        shutdownProc.running = true;
    }

    function reboot() {
        rebootProc.running = true;
    }

    function hibernate() {
        hibernateProc.running = true;
    }

    function lock() {
        lockProc.running = true;
    }

    function suspend() {
        suspendProc.running = true;
    }

    Process {
        id: shutdownProc
        command: ["systemctl", "poweroff"]
        running: false
    }
    Process {
        id: rebootProc
        command: ["systemctl", "reboot"]
        running: false
    }
    Process {
        id: hibernateProc
        command: ["systemctl", "hibernate"]
        running: false
    }
    Process {
        id: suspendProc
        command: ["systemctl", "suspend"]
        running: false
    }
    Process {
        id: lockProc
        command: ["hyprlock"]
        running: false
    }
}
