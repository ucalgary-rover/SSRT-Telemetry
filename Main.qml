import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import SSRTelemetry

// ApplicationWindow {
//     id: root

//     color: "#F3D5B5"

//     width: 1500
//     height: 800
//     visible: true
//     title: qsTr("Hello World")

//     RoverAngle {
//         id: angleController
//     }

//     Row {
//         anchors.fill: parent

//         component PlaceholderRectangle: Rectangle {
//             property alias text: placeholderText.text

//             color: "transparent"
//             border.color: "#42271C"
//             border.width: 3

//             Text {
//                 id: placeholderText
//                 anchors.verticalCenter: parent.verticalCenter
//                 anchors.horizontalCenter: parent.horizontalCenter
//             }
//         }

//         // placeholder for map
//         PlaceholderRectangle {
//             width: parent.width * 0.75
//             height: parent.height
//             anchors.left: parent.left
//             text: qsTr("Map Implementation")
//         }

//         Column {
//             width: parent.width * 0.25
//             height: parent.height
//             anchors.right: parent.right

//             // x angle view
//             PlaceholderRectangle {
//                 width: parent.width
//                 height: parent.height * 0.25
//                 anchors.top: parent.top
//                 clip: true

//                 // x angle rover view
//                 Rectangle {
//                     width: parent.width * 0.6
//                     height: parent.height * 0.4
//                     anchors.verticalCenter: parent.verticalCenter
//                     anchors.horizontalCenter: parent.horizontalCenter

//                     rotation: angleController.x_angle

//                     Text {
//                         anchors.right: parent.left
//                         anchors.rightMargin: 15
//                         anchors.verticalCenter: parent.verticalCenter

//                         text: qsTr("Front")
//                     }
//                 }
//             }

//             // y angle view
//             PlaceholderRectangle {
//                 width: parent.width
//                 height: parent.height * 0.25
//                 anchors.top: parent.top
//                 anchors.topMargin: parent.height * 0.25
//                 clip: true

//                 // y angle rover display
//                 Rectangle {
//                     width: parent.width * 0.6
//                     height: parent.height * 0.4
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     anchors.verticalCenter: parent.verticalCenter

//                     rotation: angleController.y_angle

//                     Text {
//                         anchors.horizontalCenter: parent.horizontalCenter
//                         anchors.verticalCenter: parent.verticalCenter

//                         text: qsTr("Front")
//                     }
//                 }
//             }

//             // placeholder for other component
//             PlaceholderRectangle {
//                 width: parent.width
//                 height: parent.height * 0.5
//                 anchors.bottom: parent.bottom
//                 text: qsTr("Other Implementation")
//             }
//         }
//     }

//     Dialog {
//         id: dangerDialog
//         title: qsTr("Danger Alert!")
//         visible: angleController.x_danger || angleController.y_danger
//         modal: true
//         standardButtons: Dialog.Ok
//         anchors.centerIn: parent


//         Text {
//             text: {
//                 if(angleController.x_danger && angleController.y_danger) {
//                     return qsTr("Warning! Both X and Y angles of the rover are at a dangerous level")
//                 }
//                 else if(angleController.x_danger) {
//                     return qsTr("Warning! X angle of the rover is at a dangerous level")
//                 }
//                 else {
//                     return qsTr("Warning! Y angle of the rover is at a dangerous level")
//                 }
//                 // we don't need to have a catch-all end condition since this dialolg is only triggered
//                 // when one or more of the danger thresholds are reached
//             }
//         }

//         // reset flags when accepted
//         onAccepted: {
//             angleController.set_x_danger(false)
//             angleController.set_y_danger(false)

//             // TODO: add cooldown to prevent notification spam
//         }
//     }
// }

Window {
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Shulich Space Rover Team")

    // Use the Loader to instantiate and display the component
    Loader {
        anchors.centerIn: parent
        source: "qrc:/SSRT_UI/Homepage/BasePage.qml"
    }
    // StackView {
    //     id: stackView
    //     anchors.fill:parent
    //     initialItem: "qrc:/SSRT_UI/LoadingPage/Loading_Page.ui.qml"
    // }
}

