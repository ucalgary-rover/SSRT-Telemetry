import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    width: 1920
    height: 1080
    visible: true
    title: qsTr("SSRT - Rover Telemetry")
    color: "#F3D5B5"

    ColumnLayout {
        anchors.fill: parent

        // Navigation bar loader at the top
        Loader {
            id: navLoader
            source: "qrc:/SSRT_UI/Components/Application_Layout.qml"
        }

        // Page content loader below the navigation bar
        Loader {
            id: pageLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: "qrc:/SSRT_UI/Homepage/BasePage.qml"
        }
    }

    // Connections for handling nav bar signals
    Connections {
        target: navLoader.item
        onTelemetryClicked: pageLoader.source = "qrc:/SSRT_UI/Homepage/BasePage.qml"
        onCameraClicked: pageLoader.source = "qrc:/SSRT_UI/CameraPage/CameraPage.qml"
    }
}
