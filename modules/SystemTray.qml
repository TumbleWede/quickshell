import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "../components"

RowLayout {
    spacing: 0

    Repeater {
        model: SystemTray.items

        ImageButton {
            id: root

            // Layout
            iconHeight: 16
            Layout.preferredWidth: 24

            // Appearance
            visible: modelData.status > 0 // Hide passive/idle items

            // Content
            source: modelData.icon

            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
                anchor.item: root
                anchor.edges: Edges.Bottom
            }

            // Behavior
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    modelData.activate()
                } else if (mouse.button === Qt.RightButton) {
                    menuAnchor.open()
                } else if (mouse.button === Qt.MiddleButton) {
                    modelData.secondaryActivate()
                }
            }
        }
    }
}
