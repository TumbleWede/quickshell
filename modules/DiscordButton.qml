import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../components"

TextButton {
    id: root

    property string unreadText: " "

    onClicked: Hyprland.dispatch("hl.dsp.focus { window = 'class:vesktop' }")

    Process {
        id: discordCheck
        command: ["bash", Quickshell.shellDir + "/scripts/discord.sh"]

        stdout: SplitParser {
            onRead: data => {
                try {
                    let parsed = JSON.parse(data);
                    root.unreadText = parsed.text;
                } catch (e) {
                    console.warn("Failed to parse script output:", data);
                }
            }
        }
    }

    // Timer to trigger the process every 5 seconds
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true // Runs immediately on load
        onTriggered: discordCheck.running = true
    }

    // Automatically updates reactive text
    text: unreadText
}
