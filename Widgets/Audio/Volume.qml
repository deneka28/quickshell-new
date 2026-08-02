import QtQuick

import "../../Services"

Text {
    text: AudioService.volume * 100 + "%"
}
