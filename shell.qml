//@ pragma UseQApplication
import Quickshell
import QtQuick
import QtQuick.Layouts
import "modules"
import "components"

PanelWindow {
    id: root

    // Theme
    property color colBg: "#000000"
    property color colText: "#ffffff"
    property color colBorder: "#ffffff"
    property Gradient gradientSelected: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0) }
        GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.1) }
    }
    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14
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

        IdleInhibitorButton {}
        VolumeButton {}
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
