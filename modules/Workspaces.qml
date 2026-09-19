import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../components"

Repeater {
    model: 9

    TextButton {
        property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
        property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

        Layout.preferredWidth: 24
        text: index + 1

        selected: isActive
        visible: isActive || ws !== undefined
        onClicked: Hyprland.dispatch("hl.dsp.focus { workspace = " + (index + 1) + "}")
    }
}
