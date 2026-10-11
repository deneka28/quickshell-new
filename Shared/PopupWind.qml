import QtQuick
import Quickshell
import "../Configs"

PopupWindow {
    id: root
    color: "transparent"

    visible: false

    // Привязка к кнопке — передаём снаружи
    property Item anchorItem: null
    //property int radius: 13

    property int animationDuration: 300
    property int easingType: Easing.OutBack
    property real startScale: 0.85
    property real endScale: 1.0
    property bool isClosing: false
    property bool shouldShow: false
    property int curveRadius: 13
    signal closeAnimationFinished
    property bool isTop: true
    property string direction: "down" // left, right, up, down

    readonly property int actualStartX: {
        switch (direction) {
        case "left":
            return width;
        case "right":
            return -width;
        default:
            return 0;
        }
    }
    readonly property int actualEndX: 0
    readonly property int actualStartY: {
        switch (direction) {
        case "up":
            return height;
        case "down":
            return -height;
        default:
            return 0;
        }
    }
    readonly property int actualEndY: 0

    // Привязываем к элементу
    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom
    // anchor.gravity: Edges.Bottom
    anchor.rect.y: anchorItem ? anchorItem.height + 4 : 0
    anchor.rect.x: anchorItem.width / -2

    width: implicitWidth + curveRadius * 2
    height: implicitHeight
    implicitWidth: 400
    implicitHeight: 250

    function show() {
        closeTimer.stop();
        isClosing = false;
        shouldShow = true;
        visible = true;
    }

    function hide() {
        shouldShow = false;
        isClosing = false;
        visible = false;
    }

    function closeWithAnimation() {
        if (visible && !isClosing) {
            isClosing = true;
        }
    }

    default property alias contentItem: contentContainer.children

    Timer {
        id: closeTimer
        interval: root.animationDuration + 50
        onTriggered: {
            if (root.isClosing) {
                root.visible = false;
                root.shouldShow = false;
                root.isClosing = false;
                root.closeAnimationFinished();
            }
        }
    }

    onIsClosingChanged: {
        if (isClosing)
            closeTimer.start();
        else
            closeTimer.stop();
    }

    Rectangle {
        id: backgroundRect
        anchors {
            fill: parent
            leftMargin: root.curveRadius
            rightMargin: root.curveRadius
        }
        color: Config.colors.widgetcolor
        bottomLeftRadius: 13
        bottomRightRadius: 13
        // Анимации
        transform: [
            Translate {
                id: slideTransform
                x: root.shouldShow && !root.isClosing ? root.actualEndX : root.actualStartX
                y: root.shouldShow && !root.isClosing ? root.actualEndY : root.actualStartY
                Behavior on x {
                    enabled: root.direction === "left" || root.direction === "right"
                    NumberAnimation {
                        duration: root.animationDuration
                        easing.type: root.easingType
                        easing.overshoot: 0.6
                    }
                }
                Behavior on y {
                    enabled: root.direction === "up" || root.direction === "down"
                    NumberAnimation {
                        duration: root.animationDuration
                        easing.type: root.easingType
                        easing.overshoot: 0.5
                    }
                }
            },
            Scale {
                id: scaleTransform
                origin.x: backgroundRect.width / 2
                origin.y: backgroundRect.height / 2
                xScale: root.shouldShow && !root.isClosing ? root.endScale : root.startScale
                yScale: root.shouldShow && !root.isClosing ? root.endScale : root.startScale

                Behavior on xScale {
                    NumberAnimation {
                        duration: root.animationDuration
                        easing.type: Easing.OutQuart
                    }
                }
                Behavior on yScale {
                    NumberAnimation {
                        duration: root.animationDuration
                        easing.type: Easing.OutQuart
                    }
                }
            }
        ]
        opacity: root.shouldShow && !root.isClosing ? 1 : 0
        Behavior on opacity {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.OutQuad
            }
        }

        Item {
            id: contentContainer
            anchors.fill: parent
        }
    }
    ConcaneCurves {
        radius: 13
        color: Config.colors.widgetcolor
        isTop: false
        mirrored: true
        anchors.right: backgroundRect.left
        anchors.top: backgroundRect.top
        transform: Translate {
            y: slideTransform.y
        }
    }
    ConcaneCurves {
        radius: 13
        color: Config.colors.widgetcolor
        isTop: false
        mirrored: false
        anchors.left: backgroundRect.right
        anchors.top: backgroundRect.top
        transform: Translate {
            y: slideTransform.y
        }
    }
}
