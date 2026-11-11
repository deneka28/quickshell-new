//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

import "Bar"
import "Notifications"
import "Widgets/WorkspaceClock"
import "Widgets/StartMenu"
import "Osd"

ShellRoot {
    id: root
    Variants {
        model: Quickshell.screens
        delegate: OSD {
            _screen: modelData
        }
    }
    Scope {
        Bar {}
        NotificationPopups {}
        ClockWidget {}
        AppLauncher {
            id: appLauncher
        }
    }
}
