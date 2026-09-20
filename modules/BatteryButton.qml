import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../components"

TextButton {
    id: root

    // Parameters
    property var panelWindow

    // Variables
    // Run `ls /sys/class/power_supply/` to find the correct battery name
    property string batteryPath: "/sys/class/power_supply/BAT1"

    property int capacity: 0
    property string status: "Unknown"   // Charging, Discharging, Full, Not charging
    property string timeRemaining: "Calculating…"

    readonly property string icon: {
        if (status === "Charging") return "󰂄"
        if (capacity >= 95) return "󰁹"
        if (capacity >= 80) return "󰂂"
        if (capacity >= 60) return "󰂀"
        if (capacity >= 40) return "󰁾"
        if (capacity >= 20) return "󰁼"
        return "󰁺"
    }

    // Layout
    maxText: "󰂄 99%"

    // Content
    text: `${icon} ${capacity}%`

    PopupWindow {
        id: popup
        anchor.window: root.panelWindow
        anchor.rect.x: root.x
        anchor.rect.y: root.height
        implicitWidth: infoColumn.implicitWidth + doublePadding
        implicitHeight: infoColumn.implicitHeight + 2
        visible: false

        Rectangle {
            anchors.fill: parent
            color: colBg
            border.color: colBorder
            border.width: 1

            ColumnLayout {
                id: infoColumn
                anchors.fill: parent
                anchors.margins: 1
                anchors.leftMargin: 4
                spacing: 0

                Text {
                    text: `${root.status}`
                    color: colText
                    font.family: fontFamily
                    font.pixelSize: fontSize
                }
                Text {
                    text: root.timeRemaining
                    color: colText
                    font.family: fontFamily
                    font.pixelSize: fontSize
                }
            }
        }
    }

    // Behavior
    onClicked: popup.visible = !popup.visible

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capacityProc.running = true
            statusProc.running = true
            timeProc.running = true
        }
    }

    Process {
        id: capacityProc
        command: ["cat", root.batteryPath + "/capacity"]
        stdout: SplitParser {
            onRead: data => root.capacity = parseInt(data.trim()) || 0
        }
    }

    Process {
        id: statusProc
        command: ["cat", root.batteryPath + "/status"]
        stdout: SplitParser {
            onRead: data => root.status = data.trim()
        }
    }

    // upower gives a human-readable time estimate; fallback if unavailable
    Process {
        id: timeProc
        command: ["sh", "-c",
            `upower -i $(upower -e | grep BAT) | grep -E 'time to (empty|full)' | awk -F: '{print $2}'`]
        stdout: SplitParser {
            onRead: data => {
                const trimmed = data.trim()
                root.timeRemaining = trimmed.length > 0 ? trimmed : "Unknown"
            }
        }
    }
}
