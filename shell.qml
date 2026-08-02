//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

import "Bar"

ShellRoot {
    id: root

    Scope {
        Bar {}
    }
}
