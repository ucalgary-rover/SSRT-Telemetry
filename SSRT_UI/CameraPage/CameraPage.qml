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
            id: cameraGrid
            columns: 4
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill: parent
            Camera_View_Layout {
                id: camera_View_Layout1
                camera_Text: "Camera 1"
                cameraIndex: 0
                active: cameraCheckboxes.camera1Checkbox.checked
            }
            Camera_View_Layout {
                id: camera_View_Layout2
                camera_Text: "Camera 2"
                cameraIndex: 4
                active: cameraCheckboxes.camera2Checkbox.checked
            }
            Camera_View_Layout {
                id: camera_View_Layout3
                camera_Text: "Camera 3"
                cameraIndex: 8
                active: cameraCheckboxes.camera3Checkbox.checked
            }
            Camera_View_Layout {
                id: camera_View_Layout4
                camera_Text: "Camera 4"
                // cameraIndex: 12
                active: cameraCheckboxes.camera4Checkbox.checked
            }
            Camera_View_Layout {
                id: camera_View_Layout5
                camera_Text: "Camera 5"
                active: cameraCheckboxes.camera5Checkbox.checked
            }
            Camera_View_Layout {
                id: camera_View_Layout6
                camera_Text: "Camera 6"
                active: cameraCheckboxes.camera6Checkbox.checked
            }
            Camera_View_Layout {
                id: camera_View_Layout7
                camera_Text: "Camera 7"
                active: cameraCheckboxes.camera7Checkbox.checked
            }
            Camera_View_Layout {
                id: camera_View_Layout8
                camera_Text: "Camera 8"
                active: cameraCheckboxes.camera8Checkbox.checked
            }
        }
    }

    footer: CameraCheckboxes {
        id: cameraCheckboxes
        // anchors.horizontalCenter: parent.horizontalCenter
        // anchors.verticalCenter: parent.verticalCenter

    }

}
