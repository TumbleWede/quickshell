import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts
import "../components"

TextButton {
    id: root

    // Variables
    property var sink: Pipewire.defaultAudioSink
    property real volume: sink?.audio?.volume ?? 0
    property bool muted: sink?.audio?.muted ?? false
    property real volumeStep: 0.05

    // Icon thresholds
    readonly property string icon: {
        if (muted || volume === 0) return "󰝟"
        if (volume < 0.34) return "󰕿"
        if (volume < 0.67) return "󰖀"
        return "󰕾"
    }

    // Layout
    Layout.preferredWidth: Math.round(label.implicitWidth) + doublePadding

    // Hidden text to keep the width fixed
    Text {
        id: label

        visible: false
        font.family: fontFamily
        font.weight: weightUnselected

        text: "󰕾 99%"
    }

    // Content
    text: `${icon} ${Math.round(volume * 100)}%`

    // Behavior
    onClicked: Quickshell.execDetached(["pavucontrol"])

    PwObjectTracker {
        objects: [root.sink]
    }

    onWheel: (event) => {
        if (!root.sink) return
        const delta = event.angleDelta.y > 0 ? root.volumeStep : -root.volumeStep
        const newVolume = Math.max(0, Math.min(1, root.sink.audio.volume + delta))
        root.sink.audio.volume = newVolume
    }
}
