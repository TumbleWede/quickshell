//@ pragma UseQApplication
import Quickshell
import QtQuick
import QtQuick.Layouts
import "modules"
import "components"

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root

            // Each instance gets its own screen from the model
            required property var modelData
            screen: modelData

            // Theme
            property color colBg: "#11111b"
            property color colText: "#cdd6f4"
            property color colBorder: "#b4befe"
            property Gradient gradientSelected: Gradient {
                GradientStop { position: 0.0; color: "#00b4befe" }
                GradientStop { position: 1.0; color: "#33b4befe" }
            }
            property string fontFamily: "JetBrainsMono Nerd Font"
            property int fontSize: 12
            property int transition: 300
            property int weightUnselected: 400
            property int weightSelected: 800
            property int doublePadding: 12

            // Layout
            anchors.top: true
            anchors.left: true
            anchors.right: true
            implicitHeight: 24

            // Appearance
            color: colBg

            // Content
            // Left & Right
            RowLayout {
                // Layout
                anchors.fill: parent
                spacing: 0

                // Content
                PowerButton { panelWindow: root }
                Workspaces {}
                Taskbar {}

                Spacer {}

                IdleInhibitorButton { panelWindow: root }
                VolumeButton {}
                BatteryButton { panelWindow: root }
                BrightnessButton {}
                CalendarButton {}
                SystemMonitorButton {}
                DiscordButton {}
                SystemTray {}
            }

            // Center (separate the two so center is always truly centered)
            RowLayout {
                // Layout
                anchors.fill: parent
                spacing: 0

                // Content
                Spacer {}

                SpotifyButton {}

                Spacer {}
            }
        }
    }
}
