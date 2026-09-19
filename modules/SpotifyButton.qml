import Quickshell.Services.Mpris
import QtQuick
import Qt5Compat.GraphicalEffects
import "../components"

TextButton {
    id: root

    // Variables
    property string playerIcon: ""  // your spotify glyph, hardcoded since you only have one entry
    property string pausedIcon: "󰏤"
    property var spotify: Mpris.players.values.find(p => p.identity === "Spotify")
    property real currentPosition: 0
    property int maxChars: 90
    property int minGradientWidth: 100

    property bool seeking: false
    property real seekRatio: 0

    function formatTime(seconds) {
        if (isNaN(seconds) || seconds < 0) return "0:00"
        const m = Math.floor(seconds / 60)
        const s = Math.floor(seconds % 60)
        return m + ":" + s.toString().padStart(2, "0")
    }

    // Appearance
    visible: root.spotify !== null

    // Content
    text: {
        if (!root.spotify) return ""
        const isPaused = root.spotify.playbackState === MprisPlaybackState.Paused
        const statusPart = isPaused ? pausedIcon : playerIcon
        const pos = formatTime(root.currentPosition)
        const len = formatTime(root.spotify.length)
        const artist = root.spotify.trackArtist || "Unknown Artist"
        const fullOutput = `${statusPart} [${pos}/${len}] ${artist} - ${root.spotify.trackTitle} | <i>${root.spotify.trackAlbum}</i>`
        return fullOutput.length > maxChars ? fullOutput.substring(0, maxChars) + "…" : fullOutput
    }

    LinearGradient {
        id: progressBar

        // Layout
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: {
            if (root.seeking) return root.seekRatio * root.width
            if (!root.spotify || !root.spotify.length || root.spotify.length <= 0) return 0
            const ratio = root.currentPosition / root.spotify.length
            // If race condition, return 0 assuming its due to song change
            return ratio > 1 ? 0 : ratio * root.width
        }

        // Appearance
        opacity: 0.5
        gradient: gradientSelected
        start: Qt.point(Math.min(width - root.minGradientWidth, 0), 0)
        end: Qt.point(width, 0)
    }

    // Behavior
    MouseArea {
        id: seekArea

        // Variables
        property real pressX: 0

        // Layout
        anchors.fill: parent
        z: 2  // above BaseButton's own MouseArea (z: 1) and above progressBar

        //Bevhaior
        cursorShape: Qt.PointingHandCursor
        preventStealing: true
        acceptedButtons: Qt.RightButton

        onPressed: (mouse) => {
            pressX = mouse.x
            root.seeking = true
            root.seekRatio = Math.max(0, Math.min(1, mouse.x / root.width))
        }
        onPositionChanged: (mouse) => {
            root.seekRatio = Math.max(0, Math.min(1, mouse.x / root.width))
        }
        onReleased: (mouse) => {
            if (root.seeking && root.spotify) {
                const seekPos = root.seekRatio * root.spotify.length
                root.spotify.position = seekPos
                root.currentPosition = seekPos
            }
            root.seeking = false
        }
    }

    onClicked: {
        if (root.spotify && root.spotify.canTogglePlaying) {
            root.spotify.togglePlaying()
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered: {
            //root.spotify = Mpris.players.values.find(p => p.identity === "Spotify")
            root.currentPosition = root.spotify ? root.spotify.position : 0
        }
    }
}
