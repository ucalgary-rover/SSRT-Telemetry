import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia
import QtQuick.Layouts

Rectangle {
    id: camera_View_Layout
    implicitWidth: 460
    implicitHeight: 415
    color: "#00ffffff"
    border.color: "#8f4c34"
    border.width: 1

    // rotation state for the video feed
    property int rotationAngle: 0
    property alias camera_Text: camera_.text
    property int cameraIndex: 0
    property bool active: true
    visible: active

    onActiveChanged: {
        if(active)
        {
            cameraPlayer.play();
        }
        else
        {
            cameraPlayer.stop();
        }
    }

    Item {
        id: mediaContainer
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            // restrict bottom to stay above the Rotate button
            bottom: rotateButton.top
        }
        clip: true

        MediaPlayer {
            id: cameraPlayer
            source: "http://127.0.0.1:5000/video_feed/" + cameraIndex // adjust URL as needed
            videoOutput: videoOutput
            autoPlay: false
        }

        VideoOutput {
            id: videoOutput
            // dynamically swap width/height so rotated video always fits
            width: (camera_View_Layout.rotationAngle % 180 === 0)
                    ? mediaContainer.width : mediaContainer.height
            height: (camera_View_Layout.rotationAngle % 180 === 0)
                    ? mediaContainer.height : mediaContainer.width
            anchors.centerIn: mediaContainer
            fillMode: VideoOutput.PreserveAspectFit
            rotation: camera_View_Layout.rotationAngle
            transformOrigin: Item.Center
        }
    }

    // Rotate button, bottom-left corner, styled like Add button
    Button {
        id: rotateButton
        text: qsTr("Rotate")
        width: 100
        height: 40

        background: Rectangle {
            anchors.fill: parent
            color: "#c85428"
            radius: 4
        }
        font.pixelSize: 12
        font.bold: true

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 3
        z: 1

        onClicked: {
            camera_View_Layout.rotationAngle =
                (camera_View_Layout.rotationAngle + 90) % 360
        }
    }

    // Start the feed when component is ready
    Component.onCompleted: {
        if (active) {
            cameraPlayer.play()
        }
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
