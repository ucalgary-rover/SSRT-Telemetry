import QtQuick
import QtQuick.Controls
import QtQuick.Studio.Components 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: check_indeterminate_small
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
        anchors.topMargin: 11
        anchors.bottomMargin: 11
        strokeWidth: 0.025
        strokeStyle: 1
        strokeColor: "transparent"
        path: "M 0 2 L 0 0 L 12 0 L 12 2 L 0 2 Z"
        joinStyle: 0
        fillColor: "#1d1b20"
        antialiasing: true
    }
}

/*##^##
Designer {
    D{i:0;uuid:"5b28e73f-eff5-5b5f-bb02-b6cbecf678df"}D{i:1;uuid:"e2e7e8d1-c924-5fb3-9ec1-128016bdb681"}
}
##^##*/
