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
        id: myPopup

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
                        powerPopup.visible = false
                    }
                }
                PopupButton {
                    text: "Reboot"
                    onClicked: {
                        Quickshell.execDetached(["systemctl", "reboot"])
                        powerPopup.visible = false
                    }
                }
                PopupButton {
                    text: "Sleep"
                    onClicked: {
                        Quickshell.execDetached(["systemctl", "suspend"])
                        powerPopup.visible = false
                    }
                }
            }
        }

        // Behavior
        anchor.window: root.panelWindow
    }

    // Behavior
    onClicked: myPopup.visible = !myPopup.visible
}
