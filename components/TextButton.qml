import QtQuick
import QtQuick.Layouts

BaseButton {
    id: root

    // Parameters
    property alias text: label.text
    property var maxText: text

    // Layout
    // Use Math.round to prevent fractional pixel width
    Layout.preferredWidth: Math.round(max.implicitWidth) + doublePadding

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
        font.pixelSize: fontSize

        // Behavior
        Behavior on font.weight {
            NumberAnimation { duration: transition }
        }
    }

    // Hidden text to keep the width fixed
    Text {
        id: max

        visible: false
        font.family: fontFamily
        font.weight: weightUnselected
        font.pixelSize: fontSize

        color: "red"

        text: maxText
    }
}
