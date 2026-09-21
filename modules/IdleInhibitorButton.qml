import Quickshell.Wayland
import "../components"

TextButton {
    id: root

    property var panelWindow

    selected: idle.enabled

    text: idle.enabled ? "󰒳" : "󰒲"

    IdleInhibitor {
        id: idle
        window: root.panelWindow
        enabled: false
    }

    onClicked: {
        idle.enabled = !idle.enabled
    }
}
