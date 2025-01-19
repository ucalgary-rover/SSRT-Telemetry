import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import QtQuick.Studio.Components 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: horizontal_Full_width
    width: 320
    height: 1
    color: "transparent"

    ColumnLayout {
        id: horizontal_Full_width_instance_layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 0
        SvgPathItem {
            id: divider_Stroke_
            x: 0
            y: 0
            width: 320
            height: 1
            strokeWidth: 1
            strokeStyle: 1
            strokeColor: "transparent"
            path: "M 320 1 L 0 1 L 0 0 L 320 0 L 320 1 Z"
            joinStyle: 0
            fillColor: "#cac4d0"
            antialiasing: true
            Layout.preferredHeight: 1
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
        }
    }
}

/*##^##
Designer {
    D{i:0;uuid:"3ca55eee-f110-5230-9b31-63702f820586"}D{i:1;uuid:"3ca55eee-f110-5230-9b31-63702f820586_VERTICAL"}
D{i:2;uuid:"7071738e-51eb-5f94-bea1-6492d28f956e"}
}
##^##*/
