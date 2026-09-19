import Quickshell.Wayland
import "../components"

TextButton {
    selected: idle.enabled

    text: idle.enabled ? "󰒳" : "󰒲"

    IdleInhibitor {
        id: idle
        enabled: false
    }

    onClicked: {
        idle.enabled = !idle.enabled
    }
}
