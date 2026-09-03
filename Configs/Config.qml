// Central config file
pragma Singleton
import QtQuick

QtObject {
    id: root

    property QtObject colors
    property string name: "alex"
    // default font
    property font font: Qt.font({
        "family": "Ubuntu"
    })
    property var keyboardLayouts: [
        {
            "code": "us",
            "label": "English (US)",
            "color": "dadada",
            "default": true
        },
        {
            "code": "ru",
            "label": "Russian",
            "color": "dadada",
            "default": false
        }
    ]

    Component.onCompleted: () => {
        console.log("Hello, " + root.name + "!");
    }

    colors: QtObject {
        // surface colors
        property string neutral: "#010C1D"
        property string fontcolor: '#dadada'
        property string widgetcolor: '#3b454b'
        // property string widgetcolor: 'transparent'
        property string widgetcolormidle: '#484848'
        property string widgetcolorhard: '#437496'
        property string controlscolor: '#806a6a6a'
        property string bgcolor: '#6e7a7c7d'
        property string shadow: "#000000"
    }
}
