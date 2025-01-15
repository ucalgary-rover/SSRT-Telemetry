import QtQuick
import QtQuick.Controls
import QtQuick.Studio.Components 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: check_small
    width: 24
    height: 24
    color: "transparent"

    SvgPathItem {
        id: icon
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 6
        anchors.rightMargin: 6
        anchors.topMargin: 7
        anchors.bottomMargin: 8
        strokeWidth: 0.025
        strokeStyle: 1
        strokeColor: "transparent"
        path: "M 4 9.40000057220459 L 0 5.40000057220459 L 1.399999976158142 4.000000476837158 L 4 6.600000381469727 L 10.600000381469727 0 L 12 1.4000000953674316 L 4 9.40000057220459 Z"
        joinStyle: 0
        fillColor: "#1d1b20"
        antialiasing: true
    }
}

/*##^##
Designer {
    D{i:0;uuid:"51e15e25-a316-5eee-82de-32ef4a19a627"}D{i:1;uuid:"56ae1603-5083-571c-bdda-3a566034cf76"}
}
##^##*/
