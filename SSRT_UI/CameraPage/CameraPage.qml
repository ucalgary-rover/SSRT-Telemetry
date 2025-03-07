import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts 1.15
import "../Components"

StackLayout {
    anchors.fill: parent
    width: parent.width
    currentIndex: tabBar.currentIndex
    Page {
        header: Application_Layout {
            id: application_Layout
            width: 1920
            height: 150
            anchors.left: parent.left
            anchors.top: parent.top

            onTelemetryClicked: {
                pageLoader.source = "qrc:/SSRT_UI/Homepage/BasePage.qml"
            }

            onCameraClicked:{
                pageLoader.source = "qrc:/SSRT_UI/CameraPage/CameraPage.qml"
            }

        }

        Item {
            id:telemetrytabbutton
        }

        Item {
            id:camerabutton
        }


    }
}
