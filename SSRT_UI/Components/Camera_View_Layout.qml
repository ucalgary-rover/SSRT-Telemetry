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

    // no focus here, so CameraPage keeps it
    focus: false

    property alias camera_Text: camera_.text
    property int cameraIndex: 0

    // track whether ArUco detection is on (bound by parent)
    property bool detectionEnabled: true

    property string feedUrl:
        "http://127.0.0.1:5000/video_feed/"
        + cameraIndex
        + "?detect="
        + (detectionEnabled ? "1" : "0")

    // when parent flips `detectionEnabled`, reload
    onFeedUrlChanged: {
        if (active) {
            cameraPlayer.stop()
            cameraPlayer.source = feedUrl
            cameraPlayer.play()
        }
    }

    // — show / hide the whole view —
    property bool active: true
    visible: active

    onActiveChanged: {
        if (active) cameraPlayer.play()
        else          cameraPlayer.stop()
    }

    Item {
        anchors.fill: parent

        MediaPlayer {
            id: cameraPlayer
            source: feedUrl
            videoOutput: videoOutput
            autoPlay: false
        }

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectFit
        }
    }

    Component.onCompleted: {
        if (active) cameraPlayer.play()
    }

    Text {
        id: camera_
        width: 112
        height: 29
        z: 1
        color: "#ffffff"
        text: qsTr("Camera #")
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 10
        anchors.bottomMargin: 3
        font.pixelSize: 24
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignTop
        wrapMode: Text.NoWrap
        font.weight: Font.Normal
        font.family: "Inter"
    }
}
