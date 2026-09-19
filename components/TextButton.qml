import QtQuick
import QtQuick.Layouts

BaseButton {
    id: root

    // Parameters
    property alias text: label.text

    // Layout
    // Use Math.round to prevent fractional pixel width
    Layout.preferredWidth: Math.round(label.implicitWidth) + doublePadding

    // Content
    Text {
        id: label

        // Layout
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -1

        // Appearance
        color: colText
        font.family: fontFamily
        font.weight: selected ? weightSelected : weightUnselected

        // Behavior
        Behavior on font.weight {
            NumberAnimation { duration: transition }
        }
    }
}
