import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../components"

TextButton {
    id: root

    // Variables
    property int cpu: 0
    property int mem: 0
    property int gpu: 0

    property real prevTotal: 0
    property real prevIdle: 0

    // Content
    text: `C:${String(cpu).padStart(2, ' ')}% G:${String(gpu).padStart(2, '0')}% M:${String(mem).padStart(2, '0')}%`

    // Layout
    Layout.preferredWidth: Math.round(label.implicitWidth) + doublePadding

    // Hidden text to keep the width fixed
    Text {
        id: label

        visible: false
        font.family: fontFamily
        font.weight: weightUnselected

        text: "C:99% G:99% M:99%"
    }


    // Behavior
    onClicked: Quickshell.execDetached(["flatpak", "run", "net.nokyan.Resources"])

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true
            memProc.running = true
            gpuProc.running = true
        }
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "grep 'cpu ' /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                const p = data.trim().split(/\s+/).slice(1).map(Number)
                const idle = p[3] + p[4]
                const total = p.reduce((a, b) => a + b, 0)
                const dt = total - root.prevTotal
                const di = idle - root.prevIdle
                if (dt > 0) root.cpu = Math.round((1 - di / dt) * 100)
                root.prevTotal = total
                root.prevIdle = idle
            }
        }
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | awk '/Mem:/ {printf \"%d\", ($2-$7)/$2*100}'"]
        stdout: SplitParser {
            onRead: data => root.mem = parseInt(data.trim()) || 0
        }
    }

    Process {
        id: gpuProc
        // NVIDIA example — swap for your actual GPU vendor
        command: ["sh", "-c", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits"]
        stdout: SplitParser {
            onRead: data => root.gpu = parseInt(data.trim()) || 0
        }
    }
}
