import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Components"
import "../"
import "../AddtionalUIComponents/"

Rectangle {
    id: cameraCheckBoxBar
    width: 1920
    height: 79
    color: "#f3d5b5"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    ColumnLayout {
        id: mainColumn
        anchors.fill: parent

        Rectangle {
            id: divider
            width: parent.width
            height: 2
            color: "#7b664c"
        }
        Rectangle {
            id: barContainer
            width: parent.width
            height: 70
            color: "transparent"

            RowLayout {
                id: checkBoxLayout
                anchors.fill: parent
                spacing: 70

                // Define aliases on the RowLayout itself
                property alias camera1: camera1Checkbox
                property alias camera2: camera2Checkbox
                property alias camera3: camera3Checkbox
                property alias camera4: camera4Checkbox
                property alias camera5: camera5Checkbox
                property alias camera6: camera6Checkbox
                property alias camera7: camera7Checkbox
                property alias camera8: camera8Checkbox

                CameraCheckbox { id: camera1Checkbox; cameraNum: "Camera 1" }
                CameraCheckbox { id: camera2Checkbox; cameraNum: "Camera 2" }
                CameraCheckbox { id: camera3Checkbox; cameraNum: "Camera 3" }
                CameraCheckbox { id: camera4Checkbox; cameraNum: "Camera 4" }
                CameraCheckbox { id: camera5Checkbox; cameraNum: "Camera 5" }
                CameraCheckbox { id: camera6Checkbox; cameraNum: "Camera 6" }
                CameraCheckbox { id: camera7Checkbox; cameraNum: "Camera 7" }
                CameraCheckbox { id: camera8Checkbox; cameraNum: "Camera 8" }
            }
        }
    }

    // Now expose these as properties on the outer Rectangle:
    property alias camera1Checkbox: checkBoxLayout.camera1
    property alias camera2Checkbox: checkBoxLayout.camera2
    property alias camera3Checkbox: checkBoxLayout.camera3
    property alias camera4Checkbox: checkBoxLayout.camera4
    property alias camera5Checkbox: checkBoxLayout.camera5
    property alias camera6Checkbox: checkBoxLayout.camera6
    property alias camera7Checkbox: checkBoxLayout.camera7
    property alias camera8Checkbox: checkBoxLayout.camera8
}
