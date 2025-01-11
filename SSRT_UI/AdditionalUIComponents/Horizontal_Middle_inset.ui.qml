import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import QtQuick.Studio.Components 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: horizontal_Middle_inset
    width: 320
    height: 1
    color: "transparent"

    ColumnLayout {
        id: horizontal_Middle_inset_instance_layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 0
        SvgPathItem {
            id: divider_Stroke_
            x: 16
            y: 0
            width: 288
            height: 1
            strokeWidth: 1
            strokeStyle: 1
            strokeColor: "transparent"
            path: "M 288 1 L 0 1 L 0 0 L 288 0 L 288 1 Z"
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
    D{i:0;uuid:"56f17b16-41d1-5345-9e4c-0d8f45483a3a"}D{i:1;uuid:"56f17b16-41d1-5345-9e4c-0d8f45483a3a_VERTICAL"}
D{i:2;uuid:"75d68746-4221-5619-919c-a3b982e6a90a"}
}
##^##*/

