import QtQuick
import QtQuick.Controls

Rectangle {
    id: camera_View_Layout
    implicitWidth: 460
    implicitHeight: 415
    color: "#00ffffff"
    border.color: "#8f4c34"
    border.width: 1
    property alias camera_Text: camera_.text

    Rectangle {
        id: camera_Fill
        width: 114
        height: 35
        opacity: 0.3
        color: "#8f4c34"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 346
        anchors.topMargin: 380
    }

    Text {
        id: camera_
        width: 112
        height: 29
        color: "#ffffff"
        text: qsTr("Camera #")
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 347
        anchors.topMargin: 383
        font.pixelSize: 24
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.NoWrap
        font.weight: Font.Normal
        font.family: "Inter"
    }
}

/*##^##
Designer {
    D{i:0;uuid:"5d4cef6b-38ee-5c15-9dc6-3796fcfddafd"}D{i:1;uuid:"5c08bd19-524f-565b-accc-ecfc58f1bee6"}
D{i:2;uuid:"62c5a0cb-ad68-5992-8a81-242163e88e3f"}
}
##^##*/
