import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Components"
import "../"
import "../AddtionalUIComponents/"

Page {
    visible: true;
    Rectangle {
        color: "#f3d5b5"
        anchors.fill: parent

        GridLayout {
            property int cameraCount: 8
            id: cameraGrid
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent
            rowSpacing: 10
            columnSpacing: 30
            columns: 4

            Camera_View_Layout {
                id: camera_View_Layout1
                //color: "red"
                Layout.fillWidth: active ? true : false
                Layout.fillHeight: active ? true : false
                camera_Text: "Camera 1"
                cameraIndex: 0
                active: cameraCheckboxes.camera1Checkbox.checked
                visible: active
            }

            Camera_View_Layout {
                id: camera_View_Layout2
                //color: "blue"
                Layout.fillWidth: active ? true : false
                Layout.fillHeight: active ? true : false
                camera_Text: "Camera 2"
                cameraIndex: 4
                active: cameraCheckboxes.camera2Checkbox.checked
                visible: active
            }
            Camera_View_Layout {
                id: camera_View_Layout3
                //color: "green"
                Layout.fillWidth: active ? true : false
                Layout.fillHeight: active ? true : false
                camera_Text: "Camera 3"
                cameraIndex: 8
                active: cameraCheckboxes.camera3Checkbox.checked
                visible: active

            }
            Camera_View_Layout {
                id: camera_View_Layout4
                //color:"yellow"
                Layout.fillWidth: active ? true : false
                Layout.fillHeight: active ? true : false
                camera_Text: "Camera 4"
                cameraIndex: 12
                active: cameraCheckboxes.camera4Checkbox.checked
                visible: active

            }
            Camera_View_Layout {
                id: camera_View_Layout5
                //color: "red"
                Layout.fillWidth: active ? true : false
                Layout.fillHeight: active ? true : false
                camera_Text: "Camera 5"
                active: cameraCheckboxes.camera5Checkbox.checked
                visible: active

            }
            Camera_View_Layout {
                id: camera_View_Layout6
                //color: "blue"
                Layout.fillWidth: active ? true : false
                Layout.fillHeight: active ? true : false
                camera_Text: "Camera 6"
                active: cameraCheckboxes.camera6Checkbox.checked
                visible: active

            }
            Camera_View_Layout {
                id: camera_View_Layout7
                //color: "green"
                Layout.fillWidth: active ? true : false
                Layout.fillHeight: active ? true : false
                camera_Text: "Camera 7"
                active: cameraCheckboxes.camera7Checkbox.checked
                visible: active

            }
            Camera_View_Layout {
                id: camera_View_Layout8
                //color: "yellow"
                Layout.fillWidth: active ? true : false
                Layout.fillHeight: active ? true : false
                camera_Text: "Camera 8"
                active: cameraCheckboxes.camera8Checkbox.checked
                visible: active
            }
        }
    }

    footer: CameraCheckboxes {
        id: cameraCheckboxes
        // anchors.horizontalCenter: parent.horizontalCenter
        // anchors.verticalCenter: parent.verticalCenter

    }

}
