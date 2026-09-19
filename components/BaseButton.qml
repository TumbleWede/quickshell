// Make a custom button so we don't have to deal with the ugly controls styling
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: root

    // Parameters
    property bool selected: false
    property alias hovered: mouseArea.containsMouse
    property alias acceptedButtons: mouseArea.acceptedButtons
    property var gradientStart: Qt.point(0, 0)
    property var gradientEnd: Qt.point(0, height)
    property alias barVisible: bar.visible

    signal clicked(var mouse)
    signal wheel(var event)

    // Variables
    property real opacityBg: selected ? 1 : (mouseArea.containsMouse ? 0.5 : 0)

    // Layout
    Layout.fillHeight: true

    // Content
    LinearGradient {
        id: gradientSource

        // Layout
        anchors.fill: parent
        start: gradientStart
        end: gradientEnd

        // Appearance
        opacity: opacityBg
        gradient: gradientSelected

        // Behavior
        Behavior on opacity {
            NumberAnimation { duration: transition }
        }
    }

    Rectangle {
        id: bar

        // Layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 2

        // Appearance
        color: colBorder
        opacity: opacityBg

        // Behavior
        Behavior on opacity {
            NumberAnimation { duration: transition }
        }
    }

    MouseArea {
        id: mouseArea

        // Layout
        anchors.fill: parent
        z: 1

        // Behavior
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: (mouse) => root.clicked(mouse)
        onWheel: (wheelEvent) => root.wheel(wheelEvent)
    }
}
