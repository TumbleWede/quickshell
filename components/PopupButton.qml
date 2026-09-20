import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

TextButton {
    Layout.fillWidth: true

    gradientStart: Qt.point(0, 0)
    gradientEnd: Qt.point(width, 0)

    barVisible: false
    horizontalOffset: -1
    verticalOffset: undefined

    Rectangle {
        // Layout
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 2

        // Appearance
        color: colBorder
        opacity: opacityBg

        // Behavior
        Behavior on opacity {
            NumberAnimation { duration: transition }
        }
    }
}
