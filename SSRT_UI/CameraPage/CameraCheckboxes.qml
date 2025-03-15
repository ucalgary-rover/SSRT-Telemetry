import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import "../Components"
import "../"
import "../AddtionalUIComponents/"

Rectangle {
    id: camera_Check_Box_Bar
    implicitWidth: 1920
    implicitHeight: 79
    color: "#f3d5b5"
    //anchors.left: parent.left
    //anchors.top: parent.top
    //anchors.topMargin: 853
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    ColumnLayout {
        Rectangle {
            id: divider
            implicitWidth: 1920
            implicitHeight: 2
            //anchors.left: parent.left
            //anchors.top: parent.top
            color: "#7b664c"
        }
        Rectangle {
            id: camera_Check_Box_Bar1
            implicitWidth: 1193
            implicitHeight: 70
            color: "transparent"
            RowLayout {
                id: camera_Check_Box_Bar_layout
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: 45
                CameraCheckbox {
                    cameraNum: "Camera 1"
                    //anchors.bottom: parent.bottom
                }
                CameraCheckbox {
                    cameraNum: "Camera 2"
                    //anchors.bottom: parent.bottom
                }
                CameraCheckbox {
                    cameraNum: "Camera 3"
                    //anchors.bottom: parent.bottom
                }
                CameraCheckbox {
                    cameraNum: "Camera 4"
                    //anchors.bottom: parent.bottom
                }
                CameraCheckbox {
                    cameraNum: "Camera 5"
                    //anchors.bottom: parent.bottom
                }
                CameraCheckbox {
                    cameraNum: "Camera 6"
                    //anchors.bottom: parent.bottom
                }
                CameraCheckbox {
                    cameraNum: "Camera 7"
                    //anchors.bottom: parent.bottom
                }
                CameraCheckbox {
                    cameraNum: "Camera 8"
                    //anchors.bottom: parent.bottom
                }
            }
        }
    }
}
