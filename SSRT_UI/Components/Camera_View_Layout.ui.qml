import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia

Rectangle {
    id: camera_View_Layout
    implicitWidth: 460
    implicitHeight: 415
    color: "#00ffffff"
    border.color: "#8f4c34"
    border.width: 1
    property alias camera_Text: camera_.text
    property int cameraIndex: 0

    Item {
        id: mediaContainer
        anchors.fill: parent

        MediaPlayer {
            id: cameraPlayer
            source: "http://127.0.0.1:5000/video_feed/" + cameraIndex // adjust URL as needed
            videoOutput: videoOutput1
            autoPlay: true
        }

        VideoOutput {
            id: videoOutput1
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectFit
        }
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
