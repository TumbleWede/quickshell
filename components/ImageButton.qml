import Quickshell.Widgets
import QtQuick.Layouts

BaseButton {
    id: root

    // Parameters
    property alias source: icon.source
    property alias iconHeight: icon.implicitSize

    // Layout
    // Use Math.round to prevent fractional pixel width
    Layout.preferredWidth: Math.round(icon.implicitWidth) + 12

    // Content
    IconImage {
        id: icon

        // Layout
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -1
    }
}
