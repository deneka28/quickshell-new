import QtQuick
import QtQml

Item {
    id: root

    width: size
    height: size
    visible: isVisible

    property int size: 30               // The size of the circle in pixel
    property real arcBegin: 0            // start arc angle in degree
    property real arcEnd: 270            // end arc angle in degree
    property real arcOffset: 0           // rotation
    property bool isPie: false           // paint a pie instead of an arc
    property bool showBackground: false  // a full circle as a background of the arc
    property real lineWidth: 4          // width of the line
    property string colorCircle: '#1896df'
    property string colorBackground: '#2b2b2b'
    property bool isVisible: true

    property alias beginAnimation: animationArcBegin.enabled
    property alias endAnimation: animationArcEnd.enabled

    property int animationDuration: 200

    signal wheel(event: WheelEvent)

    onArcBeginChanged: canvas.requestPaint()
    onArcEndChanged: canvas.requestPaint()
    onArcOffsetChanged: canvas.requestPaint()
    onColorCircleChanged: canvas.requestPaint()
    onColorBackgroundChanged: canvas.requestPaint()
    onLineWidthChanged: canvas.requestPaint()

    Behavior on arcBegin {
        id: animationArcBegin
        enabled: true
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Behavior on arcEnd {
        id: animationArcEnd
        enabled: true
        NumberAnimation {
            duration: root.animationDuration
            easing.type: Easing.InOutCubic
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        // rotation: -90 + parent.arcOffset

        onPaint: {
            var ctx = getContext("2d");
            var x = width / 2;
            var y = height / 2;
            var offset = (parent.arcOffset - 90) * Math.PI / 180;
            var start = offset + Math.PI * (parent.arcBegin / 180);
            var end = offset + Math.PI * (parent.arcEnd / 180);
            ctx.reset();
            ctx.lineCap = 'round';

            if (root.isPie) {
                if (root.showBackground) {
                    ctx.beginPath();
                    ctx.fillStyle = root.colorBackground;
                    ctx.moveTo(x, y);
                    ctx.arc(x, y, width / 2, 0, Math.PI * 2, false);
                    ctx.lineTo(x, y);
                    ctx.fill();
                }
                ctx.beginPath();
                ctx.fillStyle = root.colorCircle;
                ctx.moveTo(x, y);
                ctx.arc(x, y, width / 2, start, end, false);
                ctx.lineTo(x, y);
                ctx.fill();
            } else {
                if (root.showBackground) {
                    ctx.beginPath();
                    ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, 0, Math.PI * 2, false);
                    ctx.lineWidth = root.lineWidth;
                    ctx.strokeStyle = root.colorBackground;
                    ctx.stroke();
                }
                ctx.beginPath();
                ctx.arc(x, y, (width / 2) - parent.lineWidth / 2, start, end, false);
                ctx.lineWidth = root.lineWidth;
                ctx.strokeStyle = root.colorCircle;
                ctx.stroke();
            }
        }
    }
}
