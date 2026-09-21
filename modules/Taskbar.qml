import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../components"

RowLayout {
    id: root

    // Layout
    spacing: 0

    // Variables
    property int maxLen: 40

    property string hoveredTitle: ""

    function truncateMiddle(str) {
        if (!str || str.length <= maxLen) return str
        const keep = maxLen - 1
        const front = Math.ceil(keep / 2)
        const back = Math.floor(keep / 2)
        return str.substring(0, front) + "…" + str.substring(str.length - back)
    }

    // Content
    Repeater {
        model: ToplevelManager.toplevels

        ImageButton {
            // Variables
            // Find the desktop entry whose id / StartupWMClass matches appId
            property var desktopEntry: DesktopEntries.byId(modelData.appId) ??
                DesktopEntries.applications.values.find(
                    e => e.startupClass === modelData.appId || e.id === modelData.appId
                )

            // Layout
            iconHeight: 16
            Layout.preferredWidth: 24

            // Appearance
            visible: modelData.title !== "Wayland to X Recording bridge — Xwayland Video Bridge"
            source: desktopEntry ? Quickshell.iconPath(desktopEntry.icon, "image-missing")
                : Quickshell.iconPath(modelData.appId, "image-missing")

            // Behavior
            selected: modelData.activated
            onClicked: modelData.activate()

            // Tooltip on hover
            onHoveredChanged: {
                if (hovered) root.hoveredTitle = modelData.title
                else if (root.hoveredTitle === modelData.title) root.hoveredTitle = ""
            }
        }
    }

    // Taskbar tooltip
    Item {
        id: tooltipAnchor
        Layout.preferredWidth: 0   // reports zero size to RowLayout — no space reserved, no reflow
        Layout.fillHeight: true
        Layout.leftMargin: 4

        Text {
            id: tooltip

            // Layout
            anchors.left: parent.left   // positioned relative to the zero-width anchor point
            anchors.verticalCenter: parent.verticalCenter

            // Appearance
            visible: text.length > 0
            color: colText
            font.family: fontFamily
            font.pixelSize: fontSize

            // Content
            text: root.truncateMiddle(root.hoveredTitle)
        }
    }
}
