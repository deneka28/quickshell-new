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
        // main colors
        property string mainColor0: "#111160"
        property string mainColor1: "#0F0679"
        property string mainColor2: "#1911A6"
        property string mainColor3: "#8D1B82"
        property string mainColor4: "#C80E65"
        property string mainColor5: "#FF0044"
        property string mainColor6: "#DB0037"
        // ui colors
        // -- danger
        property string red900: "#DD0039"
        property string red800: "#FF0042"
        property string red700: "#FF225B"
        property string red600: "#FF4575"
        property string red500: "#FF668D"
        // -- warning
        property string yellow900: "#FFA500"
        property string yellow800: "#EBC600"
        property string yellow700: "#FFD700"
        property string yellow600: "#FFEB3B"
        property string yellow500: "#FFEC88"
    }
}
