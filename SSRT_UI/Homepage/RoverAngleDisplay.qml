import QtQuick
import SSRTelemetry
import QtQuick.Layouts
// import QtGraphicalEffects 1.0

ColumnLayout {
    id: roverAngleDisplay

    spacing: 5


    RoverAngle {
        id: angleController
    }


    // component for individual angle views
    component SingleAngleView: Rectangle {
        property url imagePath
        // property alias imagePath: displayImage.source
        property alias text: angleLabel.text
        property alias rotation: displayImage.rotation

        clip: true
        width: parent.width // take up width of colum
        Layout.preferredHeight: parent.height / roverAngleDisplay.children.length   // evenly split height between children

        // text to be displayed (ex. front, side)
        Text {
            id: angleLabel
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 15
        }

        Rectangle {
            id: displayImage
            width: 50
            height: 50
            color: "red"

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // image to be displayed
        // Image {
        //     id: displayImage
        //     width: parent.width * 0.5
        //     fillMode: Image.PreserveAspectFit
        // }


        // ColorOverlay {
        //     anchors.fill: displayImage
        //     source: displayImage
        //     color: "#ffffff"
        // }
    }


    // X angle view
    SingleAngleView {
        text: qsTr("Front")
        imagePath: "../assets/rover-front-view.png"
        rotation: angleController.x_angle
    }

    // Y angle view
    SingleAngleView {
        text: qsTr("Side")
        imagePath: "../assets/rover-side-view.png"
        rotation: angleController.y_angle
    }

    component PlaceholderRectangle: Rectangle {
        property alias text: placeholderText.text

        color: "transparent"
        border.color: "#42271C"
        border.width: 3

        Text {
            id: placeholderText
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    /*Column {
        width: parent.width
        height: parent.height

        // X angle view
        PlaceholderRectangle {
            width: parent.width
            height: parent.height * 0.25
            anchors.top: parent.top
            clip: true

            // X angle rover view
            Rectangle {
                width: parent.width * 0.6
                height: parent.height * 0.4
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                rotation: angleController.x_angle

                Text {
                    anchors.right: parent.left
                    anchors.rightMargin: 15
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Front")
                }
            }
        }

        // Y angle view
        PlaceholderRectangle {
            width: parent.width
            height: parent.height * 0.25
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.25
            clip: true

            // Y angle rover display
            Rectangle {
                width: parent.width * 0.6
                height: parent.height * 0.4
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                rotation: angleController.y_angle

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Front")
                }
            }
        }
    } */
}
