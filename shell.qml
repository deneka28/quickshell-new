//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

import "Bar"
import "Notifications"

ShellRoot {
    id: root

    Scope {
        Bar {}
        NotificationPopups {}
    }
}
