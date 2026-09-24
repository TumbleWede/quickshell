import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components"

TextButton {
    id: root

    // Parameters
    property var panelWindow

    // Content
    text: "⏻"

    PopupWindow {
        id: popup

        // Layout
        anchor.rect.x: 0
        anchor.rect.y: root.height
        implicitWidth: 82
        implicitHeight: 74

        // Appearance
        visible: false

        // Content
        Rectangle {
            anchors.fill: parent
            color: colBg
            border.color: colBorder
            border.width: 1

            ColumnLayout {
                id: menuColumn

                // Layout
                anchors.fill: parent
                anchors.margins: 1
                spacing: 0

                // Content
                PopupButton {
                    text: "Shutdown"
                    onClicked: {
                        Quickshell.execDetached(["systemctl", "poweroff"])
                        popup.visible = false
                    }
                }
                PopupButton {
                    text: "Restart"
                    onClicked: {
                        Quickshell.execDetached(["systemctl", "reboot"])
                        popup.visible = false
                    }
                }
                PopupButton {
                    text: "Sleep"
                    onClicked: {
                        Quickshell.execDetached(["systemctl", "suspend"])
                        popup.visible = false
                    }
                }
            }
        }

        // Behavior
        anchor.window: root.panelWindow
    }

    // Behavior
    onClicked: popup.visible = !popup.visible
}
