import Quickshell

ColorQuantizer {
    id: quantizer
    source: "file:///home/alex/Pictures/wallpaper/wallpaperswide.com-2016-3d-abstract-polygon-wallpaper-cs9-fx-design-wallpaper-1920x1200.jpg"
    depth: 3        // 2³ = 8 цветов
    rescaleSize: 64 // масштабируем для быстрой обработки

    onColorsChanged: {
        console.log("Цвета:", colors);
        // colors[0] — доминирующий цвет
        // colors[1], colors[2] ... — остальные
    }
}
