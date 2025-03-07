import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick.Controls 2.15
import com.example 1.0
import SSRTelemetry

Window {
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Schulich Space Rover Team")
    color:  "#F3D5B5"

    // Use the Loader to instantiate and display the component
    Loader {
        id: pageLoader
        anchors.top: parent.top
        anchors.left: parent.top
        anchors.fill: parent
        source: "qrc:/SSRT_UI/Homepage/BasePage.qml"
        // source: "qrc:/SSRT_UI/CameraPage/Camera_Frame.ui.qml"
    }
}
