import QtQuick
import SSRTelemetry
import QtQuick.Layouts
// import QtGraphicalEffects 1.0

ColumnLayout {
    id: roverAngleDisplay

    property real warningAngleThreshold;

    spacing: 5

    RoverAngle {
        id: angleController
    }

    // component for individual angle views
    component SingleAngleView: Rectangle {
        id: singleAngleView

        property alias imagePath: displayImage.source
        property alias text: angleLabel.text
        property real angle

        clip: true
        width: parent.width // take up width of colum
        Layout.preferredHeight: parent.height / roverAngleDisplay.children.length   // evenly split height between children
        color: "transparent"

        // text to be displayed (ex. front, side)
        Text {
            id: angleLabel
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 15

            font.pointSize: 24
            font.bold: true
        }

        // Text displaying current angle
        Text {
            text: singleAngleView.angle.toFixed(3)

            anchors.top: angleLabel.bottom
            anchors.left: angleLabel.left
            anchors.topMargin: 20

            color: {
                if (Math.abs(singleAngleView.angle) > roverAngleDisplay.warningAngleThreshold) {
                    return "red"
                }
                else {
                    return "black"
                }
            }
        }

        // image to be displayed
        Image {
            id: displayImage
            width: parent.width * 0.5
            fillMode: Image.PreserveAspectFit
            rotation: singleAngleView.angle

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // X angle view
    SingleAngleView {
        text: qsTr("Front")
        imagePath: "../assets/rover-front-view.png"
        angle: angleController.x_angle
    }

    // Y angle view
    SingleAngleView {
        text: qsTr("Side")
        imagePath: "../assets/rover-side-view.png"
        angle: angleController.y_angle
    }
}
