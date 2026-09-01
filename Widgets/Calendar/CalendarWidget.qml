import QtQuick
import QtQuick.Layouts
import "../../Configs"
import "../../Shared"

Item {
    id: root

    property var today: new Date()
    property int displayYear: today.getFullYear()
    property int displayMonth: today.getMonth()

    readonly property var monthNames: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    readonly property var dayNames: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]

    function daysInMonth(y, m) {
        return new Date(y, m + 1, 0).getDate();
    }

    function firstDayOfMonth(y, m) {
        return (new Date(y, m, 1).getDay() + 6) % 7;
    }

    // Строим полный массив ячеек — пред месяц + текущий + след месяц
    property var cells: {
        const result = [];
        const firstDay = firstDayOfMonth(displayYear, displayMonth);
        const daysThisMonth = daysInMonth(displayYear, displayMonth);

        // Предыдущий месяц
        const prevMonth = displayMonth === 0 ? 11 : displayMonth - 1;
        const prevYear = displayMonth === 0 ? displayYear - 1 : displayYear;
        const daysLastMonth = daysInMonth(prevYear, prevMonth);

        for (let i = firstDay - 1; i >= 0; i--) {
            result.push({
                day: daysLastMonth - i,
                month: prevMonth,
                year: prevYear,
                currentMonth: false
            });
        }

        // Текущий месяц
        for (let d = 1; d <= daysThisMonth; d++) {
            result.push({
                day: d,
                month: displayMonth,
                year: displayYear,
                currentMonth: true
            });
        }

        // Следующий месяц — добиваем до полных недель
        const nextMonth = displayMonth === 11 ? 0 : displayMonth + 1;
        const nextYear = displayMonth === 11 ? displayYear + 1 : displayYear;
        const remaining = (7 - (result.length % 7)) % 7;

        for (let d = 1; d <= remaining; d++) {
            result.push({
                day: d,
                month: nextMonth,
                year: nextYear,
                currentMonth: false
            });
        }

        return result;
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // Навигация
        RowLayout {
            Layout.fillWidth: true

            Rectangle {
                width: 28
                height: 28
                radius: 6
                color: prevHover.containsMouse ? Config.colors.controlscolor : "transparent"
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "‹"
                    font.pixelSize: 18
                    color: Config.colors.fontcolor
                }

                MouseArea {
                    id: prevHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (root.displayMonth === 0) {
                            root.displayMonth = 11;
                            root.displayYear--;
                        } else {
                            root.displayMonth--;
                        }
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: root.monthNames[root.displayMonth] + " " + root.displayYear
                color: Config.colors.fontcolor
                font.family: Config.font
                font.pixelSize: 15
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
            }

            Rectangle {
                width: 28
                height: 28
                radius: 6
                color: nextHover.containsMouse ? Config.colors.controlscolor : "transparent"
                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: "›"
                    font.pixelSize: 18
                    color: Config.colors.fontcolor
                }

                MouseArea {
                    id: nextHover
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        if (root.displayMonth === 11) {
                            root.displayMonth = 0;
                            root.displayYear++;
                        } else {
                            root.displayMonth++;
                        }
                    }
                }
            }
        }

        // Дни недели
        Grid {
            Layout.fillWidth: true
            columns: 7
            spacing: 4

            Repeater {
                model: root.dayNames
                Text {
                    width: (root.width - 4 * 6) / 7
                    text: modelData
                    color: Config.colors.fontcolor
                    opacity: 0.4
                    font.pixelSize: 11
                    font.family: Config.font
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Config.colors.fontcolor
            opacity: 0.08
        }

        // Сетка дней
        Grid {
            Layout.fillWidth: true
            columns: 7
            spacing: 4

            Repeater {
                model: root.cells

                Rectangle {
                    required property var modelData
                    required property int index

                    property bool isToday: {
                        const t = root.today;
                        return modelData.day === t.getDate() && modelData.month === t.getMonth() && modelData.year === t.getFullYear();
                    }

                    // Выходные — сб(5) и вс(6) по индексу в неделе
                    property bool isWeekend: index % 7 === 5 || index % 7 === 6

                    width: (root.width - 4 * 6) / 7
                    height: width
                    radius: width / 2

                    color: isToday ? "#89b4fa" : dayHover.containsMouse && modelData.currentMonth ? Config.colors.controlscolor : "transparent"

                    Behavior on color {
                        ColorAnimation {
                            duration: 100
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.day
                        font.pixelSize: 12
                        font.family: Config.font
                        font.bold: parent.isToday
                        color: parent.isToday ? "#1e1e2e" : parent.isWeekend ? "#f38ba8" : Config.colors.fontcolor
                        // Дни соседних месяцев тусклее
                        opacity: modelData.currentMonth ? 1.0 : 0.3
                    }

                    MouseArea {
                        id: dayHover
                        anchors.fill: parent
                        hoverEnabled: true
                        // Клик по соседнему месяцу переключает на него
                        onClicked: {
                            if (!modelData.currentMonth) {
                                root.displayMonth = modelData.month;
                                root.displayYear = modelData.year;
                            }
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
