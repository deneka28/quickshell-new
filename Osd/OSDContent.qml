import QtQuick
import "../Services"
import "."

Item {
    anchors.fill: parent

    Loader {
        anchors.fill: parent

        sourceComponent: {
            switch (OsdService.current.type) {
            case Types.mVolume:
            case Types.mBrightness:
                return progressComponent;
            case Types.mCapsLock:
                return stateComponent;
            case Types.mLayout:
                return layoutComponent;
            default:
                return null;
            }
        }
    }

    Component {
        id: progressComponent
        ProgressOSD {}
    }

    Component {
        id: stateComponent

        StateOSD {
            service: OsdService
        }
    }

    Component {
        id: layoutComponent

        LayoutOSD {
            service: OsdService
        }
    }
}
