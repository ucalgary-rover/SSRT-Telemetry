import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import QtQuick.Studio.Components 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: vertical_Inset
    width: 1
    height: 120
    color: "transparent"

    ColumnLayout {
        id: vertical_Inset_instance_layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 16
        spacing: 0
        SvgPathItem {
            id: divider_Stroke_
            x: -52
            y: 68
            width: 104
            height: 1
            strokeWidth: 1
            strokeStyle: 1
            strokeColor: "transparent"
            rotation: 90
            path: "M 104 1 L 0 1 L 0 0 L 104 0 L 104 1 Z"
            joinStyle: 0
            fillColor: "#cac4d0"
            antialiasing: true
            Layout.preferredWidth: 104
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
        }
    }
}

/*##^##
Designer {
    D{i:0;uuid:"0d6032f5-e5be-5923-8cdd-ea6d367fd948"}D{i:1;uuid:"0d6032f5-e5be-5923-8cdd-ea6d367fd948_VERTICAL"}
D{i:2;uuid:"83a2a13e-1c4d-5db1-9dd3-5564d8f33236"}
}
##^##*/
