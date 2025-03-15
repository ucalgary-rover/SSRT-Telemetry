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

            }
            Camera_View_Layout {
                id: camera_View_Layout2
                camera_Text: "Camera 2"
            }
            Camera_View_Layout {
                id: camera_View_Layout3
                camera_Text: "Camera 3"
            }
            Camera_View_Layout {
                id: camera_View_Layout4
                camera_Text: "Camera 4"
            }
            Camera_View_Layout {
                id: camera_View_Layout5
                camera_Text: "Camera 5"
            }
            Camera_View_Layout {
                id: camera_View_Layout6
                camera_Text: "Camera 6"
            }
            Camera_View_Layout {
                id: camera_View_Layout7
                camera_Text: "Camera 7"
            }
            Camera_View_Layout {
                id: camera_View_Layout8
                camera_Text: "Camera 8"
            }
        }
    }

    footer: CameraCheckboxes {
        // anchors.horizontalCenter: parent.horizontalCenter
        // anchors.verticalCenter: parent.verticalCenter

    }

}
