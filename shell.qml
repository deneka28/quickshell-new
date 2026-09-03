//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

import "Bar"
import "Notifications"
import "Widgets/WorkspaceClock"

ShellRoot {
    id: root
    Variants {
        model: Quickshell.screens
        Scope {
            Bar {}
            NotificationPopups {}
            ClockWidget {}
        }
    }
}
