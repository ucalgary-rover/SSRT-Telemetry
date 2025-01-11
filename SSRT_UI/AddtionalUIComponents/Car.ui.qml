import QtQuick
import QtQuick.Controls

Rectangle {
    id: car
    width: 24
    height: 24
    color: "transparent"

    Image {
        id: icon
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 3
        anchors.rightMargin: 3
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        source: "assets/icon.png"
    }
}

/*##^##
Designer {
    D{i:0;uuid:"88e8371d-c6c7-5a25-a27f-aa56089a3b1b"}D{i:1;uuid:"9103d2f2-e13e-51a5-a417-213062642a42"}
}
##^##*/

