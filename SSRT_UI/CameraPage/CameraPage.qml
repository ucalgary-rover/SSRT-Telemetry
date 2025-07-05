import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../Components"
import "../"
import "../AddtionalUIComponents/"

Page {
    id: cameraPage
    visible: true

    // make this Page a focus scope and grab focus on load
    focus: true
    Keys.enabled: true
    Component.onCompleted: forceActiveFocus()

    // one master switch for all cameras
    property bool detectionEnabledAll: true

    // catch “A” at the page level
    Keys.onPressed: {
        if (event.key === Qt.Key_A) {
            detectionEnabledAll = !detectionEnabledAll
        }
    }

    Rectangle {
        color: "#f3d5b5"
        anchors.fill: parent

        GridLayout {
            id: cameraGrid
            columns: 4
            rowSpacing: 10
            columnSpacing: 30
            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            property int cameraCount: 8

            // Camera 1
            Camera_View_Layout {
                camera_Text: "Camera 1"
                cameraIndex: 0
                active: cameraCheckboxes.camera1Checkbox.checked
                visible: active
                Layout.fillWidth: active
                Layout.fillHeight: active
                detectionEnabled: cameraPage.detectionEnabledAll
            }

            // Camera 2
            Camera_View_Layout {
                camera_Text: "Camera 2"
                cameraIndex: 2
                active: cameraCheckboxes.camera2Checkbox.checked
                visible: active
                Layout.fillWidth: active
                Layout.fillHeight: active
                detectionEnabled: cameraPage.detectionEnabledAll
            }

            // Camera 3
            Camera_View_Layout {
                camera_Text: "Camera 3"
                cameraIndex: 0
                active: cameraCheckboxes.camera3Checkbox.checked
                visible: active
                Layout.fillWidth: active
                Layout.fillHeight: active
                detectionEnabled: cameraPage.detectionEnabledAll
            }

            // Camera 4
            Camera_View_Layout {
                camera_Text: "Camera 4"
                cameraIndex: 0
                active: cameraCheckboxes.camera4Checkbox.checked
                visible: active
                Layout.fillWidth: active
                Layout.fillHeight: active
                detectionEnabled: cameraPage.detectionEnabledAll
            }

            // Camera 5
            Camera_View_Layout {
                camera_Text: "Camera 5"
                cameraIndex: 0
                active: cameraCheckboxes.camera5Checkbox.checked
                visible: active
                Layout.fillWidth: active
                Layout.fillHeight: active
                detectionEnabled: cameraPage.detectionEnabledAll
            }

            // Camera 6
            Camera_View_Layout {
                camera_Text: "Camera 6"
                cameraIndex: 0
                active: cameraCheckboxes.camera6Checkbox.checked
                visible: active
                Layout.fillWidth: active
                Layout.fillHeight: active
                detectionEnabled: cameraPage.detectionEnabledAll
            }

            // Camera 7
            Camera_View_Layout {
                camera_Text: "Camera 7"
                cameraIndex: 0
                active: cameraCheckboxes.camera7Checkbox.checked
                visible: active
                Layout.fillWidth: active
                Layout.fillHeight: active
                detectionEnabled: cameraPage.detectionEnabledAll
            }

            // Camera 8
            Camera_View_Layout {
                camera_Text: "Camera 8"
                cameraIndex: 0
                active: cameraCheckboxes.camera8Checkbox.checked
                visible: active
                Layout.fillWidth: active
                Layout.fillHeight: active
                detectionEnabled: cameraPage.detectionEnabledAll
            }
        }
    }

    footer: CameraCheckboxes {
        id: cameraCheckboxes
    }
}
