pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../Configs"

PanelWindow {
    id: root
    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    function show() {
        visible = true;
        focusGrab.active = true;
    }

    function hide() {
        visible = false;
        focusGrab.active = false;
    }

    HyprlandFocusGrab {
        id: focusGrab
        windows: [root]
        onCleared: root.hide()
    }

    // Фон — полупрозрачный оверлей
    Rectangle {
        anchors.fill: parent
        color: "#cc000000"

        MouseArea {
            anchors.fill: parent
            onClicked: root.hide()
        }

        // Воркспейсы
        Flow {
            id: workspacesFlow
            anchors.centerIn: parent
            width: Math.min(parent.width * 0.9, 1400)
            spacing: 16

            Repeater {
                model: {
                    // Собираем уникальные воркспейсы из топлевелов
                    const ws = new Set();
                    for (const t of ToplevelManager.toplevels.values) {
                        if (t.workspace)
                            ws.add(t.workspace);
                    }
                    // Добавляем текущий воркспейс
                    const current = Hyprland.focusedMonitor?.activeWorkspace;
                    if (current)
                        ws.add(current.id);
                    return Array.from({
                        length: 9
                    }, (_, i) => i + 1);
                }

                delegate: WorkspacePreview {
                    required property int modelData
                    workspaceId: modelData
                    onActivated: {
                        Hyprland.dispatch("workspace", String(modelData));
                        root.hide();
                    }
                }
            }
        }
    }
}
