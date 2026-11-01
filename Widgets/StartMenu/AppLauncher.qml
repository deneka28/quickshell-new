pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import Quickshell.Io
import "../../Configs"

PanelWindow {
    id: root

    visible: false
    color: "transparent"
    PersistentProperties {
        id: appUsage

        property var usageCount: ({})
    }
    property string searchText: ""
    property string activeCategory: "Все"
    property int selectedIndex: 0
    property var filteredApps: []
    property bool closing: false

    readonly property var categories: [
        {
            name: "Все",
            icon: "󰍉"
        },
        {
            name: "Интернет",
            icon: "󰖟"
        },
        {
            name: "Разработка",
            icon: "󰅩"
        },
        {
            name: "Мультимедиа",
            icon: "󰝚"
        },
        {
            name: "Система",
            icon: "󰒓"
        }
    ]

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    IpcHandler {
        target: "launcher"

        function toggle(): void {
            if (root.visible)
                root.close();
            else
                root.open();
        }

        function open(): void {
            root.open();
        }

        function close(): void {
            root.close();
        }
    }

    function categoryMatches(app) {
        if (activeCategory === "Все")
            return true;

        const categories = (app.categories || []).join(" ").toLowerCase();

        if (activeCategory === "Интернет")
            return /network|webbrowser|email|chat|instantmessaging/.test(categories);

        if (activeCategory === "Разработка")
            return /development|ide|programming|debugger/.test(categories);

        if (activeCategory === "Мультимедиа")
            return /audio|video|music|player|graphics|photography/.test(categories);

        if (activeCategory === "Система")
            return /system|settings|utility|monitor|security/.test(categories);

        return true;
    }

    function updateApps() {
        const query = searchText.trim().toLocaleLowerCase();
        const apps = DesktopEntries.applications.values;
        const result = [];

        for (let i = 0; i < apps.length; i++) {
            const app = apps[i];

            if (app.noDisplay || !categoryMatches(app))
                continue;
            const name = (app.name || "").toLocaleLowerCase();
            const generic = (app.genericName || "").toLocaleLowerCase();
            const comment = (app.comment || "").toLocaleLowerCase();
            const keywords = (app.keywords || []).join(" ").toLocaleLowerCase();

            if (query === "" || name.includes(query) || generic.includes(query) || comment.includes(query) || keywords.includes(query)) {
                result.push(app);
            }
        }

        result.sort((a, b) => {
            const usage = appUsage.usageCount;

            const countA = usage[a.id] || 0;
            const countB = usage[b.id] || 0;

            if (countA !== countB)
                return countB - countA;

            return a.name.localeCompare(b.name);
        });

        filteredApps = result;
        selectedIndex = 0;
    }

    function open() {
        searchText = "";
        search.text = "";

        activeCategory = "Все";
        updateApps();
        visible = true;

        Qt.callLater(() => {
            search.forceActiveFocus();
        });
    }
    function close() {
        searchText = "";
        search.text = "";
        updateApps();
        visible = false;
    }

    function launchSelected() {
        if (filteredApps.length === 0)
            return;

        const app = filteredApps[selectedIndex];
        const id = app.id;

        let usage = appUsage.usageCount;
        usage[id] = (usage[id] || 0) + 1;

        appUsage.usageCount = Object.assign({}, usage);

        close();
        app.execute();
    }

    Connections {
        target: DesktopEntries

        function onApplicationsChanged() {
            root.updateApps();
        }
    }

    Item {
        id: scene
        anchors.fill: parent

        Rectangle {
            id: backdrop
            anchors.fill: parent
            color: "#cc000000"
            opacity: 0

            MouseArea {
                anchors.fill: parent
                onClicked: root.close()
            }
        }

        Rectangle {
            id: launcher

            width: Math.min(560, root.width - 40)
            height: Math.min(550, root.height - 60)
            anchors.centerIn: parent

            radius: 16
            color: Config.colors.widgetcolor

            opacity: 0
            scale: 0.94

            MouseArea {
                anchors.fill: parent
                onClicked: mouse => mouse.accepted = true
            }

            Column {
                anchors.fill: parent
                anchors.margins: 22
                spacing: 16

                Rectangle {
                    width: parent.width
                    height: 40
                    radius: 10
                    color: Config.colors.controlscolor
                    border.color: search.activeFocus ? Config.colors.borderolor : Config.colors.widgetcolorhard
                    border.width: 1

                    Behavior on border.color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 12
                        spacing: 12

                        Text {
                            text: "󰍉"
                            color: Config.colors.fontcolor
                            font.pixelSize: 28
                            font.family: "JetBrainsMono Nerd Font"
                        }

                        TextField {
                            id: search
                            width: parent.width - 48
                            anchors.verticalCenter: parent.verticalCenter

                            placeholderText: "Найти приложение..."
                            color: Config.colors.fontcolor
                            placeholderTextColor: Config.colors.darckfontcolor
                            font.family: Config.font
                            font.pixelSize: 14
                            selectByMouse: true

                            background: Rectangle {
                                color: "transparent"
                            }

                            onTextChanged: {
                                root.searchText = text;
                                root.updateApps();
                            }

                            Keys.onDownPressed: {
                                if (root.filteredApps.length > 0)
                                    root.selectedIndex = Math.min(root.selectedIndex + 1, root.filteredApps.length - 1);
                            }

                            Keys.onUpPressed: {
                                root.selectedIndex = Math.max(root.selectedIndex - 1, 0);
                            }

                            Keys.onReturnPressed: root.launchSelected()
                            Keys.onEnterPressed: root.launchSelected()
                            Keys.onEscapePressed: root.close()
                        }
                    }
                }

                Row {
                    width: parent.width
                    height: 30
                    spacing: 7

                    Repeater {
                        model: root.categories

                        delegate: Rectangle {
                            required property var modelData
                            required property int index

                            width: (parent.width - 28) / 5
                            height: 30
                            radius: 8
                            border.width: 1
                            border.color: root.activeCategory === modelData.name ? Config.colors.btncolor : Config.colors.btncolorActive
                            color: root.activeCategory === modelData.name ? Config.colors.btncolorActive : Config.colors.btncolor

                            Behavior on color {
                                ColorAnimation {
                                    duration: 140
                                }
                            }
                            Text {
                                anchors.centerIn: parent
                                text: modelData.icon
                                color: root.activeCategory === modelData.name ? Config.colors.fontcolor : Config.colors.darckfontcolor
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 28
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    root.activeCategory = modelData.name;
                                    root.updateApps();
                                }
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    height: 20

                    Text {
                        text: root.searchText === "" ? root.activeCategory : "Результаты поиска"

                        color: Config.colors.fontcolor
                        font.family: Config.font
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: 1
                        height: 1
                    }

                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        text: root.filteredApps.length + " приложений"
                        color: Config.colors.darckfontcolor
                        font.family: Config.font
                        font.pixelSize: 11
                    }
                }

                ListView {
                    id: appList

                    width: parent.width
                    height: parent.height - 150
                    clip: true
                    spacing: 5
                    model: root.filteredApps
                    currentIndex: root.selectedIndex

                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }

                    delegate: Rectangle {
                        id: appRow

                        required property var modelData
                        required property int index

                        width: appList.width
                        height: 58
                        radius: 12

                        color: index === root.selectedIndex ? Config.colors.controlscolor : hovered ? Config.colors.widgetcolorhard : "transparent"

                        property bool hovered: false

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }

                        Rectangle {
                            width: 3
                            height: 30
                            radius: 2
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            anchors.verticalCenter: parent.verticalCenter
                            color: Config.colors.indicatorcolor
                            opacity: index === root.selectedIndex ? 1 : 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 120
                                }
                            }
                        }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 12
                            spacing: 13

                            IconImage {
                                anchors.verticalCenter: parent.verticalCenter
                                width: 48
                                height: 48
                                source: Quickshell.iconPath(appRow.modelData.icon, "application-x-executable")
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width - 60
                                spacing: 4

                                Text {
                                    width: parent.width
                                    text: appRow.modelData.name || "Без названия"
                                    color: Config.colors.fontcolor
                                    font.family: Config.font
                                    font.pixelSize: 14
                                    elide: Text.ElideRight
                                }

                                Text {
                                    width: parent.width
                                    text: appRow.modelData.genericName || appRow.modelData.comment || appRow.modelData.id || ""

                                    color: Config.colors.darckfontcolor
                                    font.family: Config.font
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                appRow.hovered = true;
                                root.selectedIndex = index;
                            }

                            onExited: appRow.hovered = false

                            onClicked: {
                                root.selectedIndex = index;
                                root.launchSelected();
                            }
                        }
                    }

                    onCurrentIndexChanged: {
                        if (currentIndex >= 0 && count > 0)
                            positionViewAtIndex(currentIndex, ListView.Contain);
                    }
                }
            }
        }
    }

    ParallelAnimation {
        id: closeAnimation

        NumberAnimation {
            target: launcher
            property: "opacity"
            to: 0
            duration: 120
            easing.type: Easing.InQuad
        }

        NumberAnimation {
            target: launcher
            property: "scale"
            to: 0.96
            duration: 150
            easing.type: Easing.InQuad
        }

        NumberAnimation {
            target: backdrop
            property: "opacity"
            to: 0
            duration: 150
        }

        onFinished: {
            root.visible = false;
            root.closing = false;
        }
    }

    ParallelAnimation {
        id: openAnimation

        NumberAnimation {
            target: launcher
            property: "opacity"
            to: 1
            duration: 180
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: launcher
            property: "scale"
            to: 1
            duration: 220
            easing.type: Easing.OutBack
        }

        NumberAnimation {
            target: backdrop
            property: "opacity"
            to: 1
            duration: 200
        }
    }

    onVisibleChanged: {
        if (visible) {
            openAnimation.start();
        } else {
            openAnimation.stop();
            closeAnimation.stop();
            launcher.opacity = 0;
            launcher.scale = 0.94;
            backdrop.opacity = 0;
        }
    }

    Keys.onEscapePressed: root.close()

    Component.onCompleted: updateApps()
}
