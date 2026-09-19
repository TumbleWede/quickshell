import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components"

TextButton {
    id: root

    property var now: new Date()

    // Layout
    Layout.preferredWidth: Math.round(label.implicitWidth) + doublePadding

    // Hidden text to keep the width fixed
    Text {
        id: label

        visible: false
        font.family: fontFamily
        font.weight: weightUnselected

        text: "hh:mm:ss AP ddd M/dd/yyyy"
    }

    text: Qt.formatDateTime(now, "h:mm:ss AP ddd M/dd/yyyy")
    onClicked: Quickshell.execDetached(["flatpak", "run", "org.gnome.Calendar"])

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }
}
