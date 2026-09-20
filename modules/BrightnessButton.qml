import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../components"

TextButton {
    id: root

    // Variables
    property int brightness: 0
    property int step: 1

    readonly property string icon: {
        if (brightness >= 80) return "󰃠"
        if (brightness >= 50) return "󰃟"
        if (brightness >= 20) return "󰃞"
        return "󰃝"
    }

    // Layout
    maxText: "󰃠 99%"

    // Content
    text: `${icon} ${brightness}%`

    // Behavior
    function refresh() {
        getProc.running = true
    }

    Process {
        id: getProc
        command: ["brightnessctl", "-m"]
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(",")
                if (parts.length >= 4) {
                    root.brightness = parseInt(parts[3])  // e.g. "45%" -> 45
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    onWheel: (event) => {
        const direction = event.angleDelta.y > 0 ? "+" : "-"
        Quickshell.execDetached(["brightnessctl", "set", `${root.step}%${direction}`])
        // optimistic local update so the UI feels instant, corrected on next poll
        root.brightness = Math.max(0, Math.min(100, root.brightness + (direction === "+" ? root.step : -root.step)))
    }
}
