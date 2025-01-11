import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "../"

Rectangle {
    id: loading_Page
    width: 1920
    height: 1080
    color: "#f3d5b5"
    property alias connecting_to_Rover_Text: connecting_to_Rover_.text

    Image {
        id: sSRT_Logo
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 765
        anchors.rightMargin: 765
        anchors.topMargin: 348
        anchors.bottomMargin: 342
        source: "../assets/sSRT_Logo.png"
    }

    BusyIndicator {
                id: busyIndicator
                x: 628
                y: 294
                width: 664
                height: 492
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 700
                anchors.rightMargin: 700
                anchors.topMargin: 306
                anchors.bottomMargin: 300
                Material.accent: "#C85428"
            }

    Text {
        id: connecting_to_Rover_
        width: 500
        color: "#390c00"
        text: qsTr("Connecting to Rover...")
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 786
        anchors.bottomMargin: 237
        font.pixelSize: 40
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.Wrap
        font.weight: Font.Normal
        font.family: "Inter"
        anchors.horizontalCenterOffset: 29
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

/*##^##
Designer {
    D{i:0;uuid:"4b8e19b3-b78a-53d2-b923-d6fa9e565c10"}D{i:1;uuid:"c10ad936-759b-5b5b-9f42-bdae0f4f351a"}
}
##^##*/

