import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SSRTelemetry

ApplicationWindow {
    id: window
    width: 600
    height: 400
    visible: true
    title: qsTr("SSRT - Rover Telemetry")
    color: "#F3D5B5"

    // Loader fills the entire window
    Loader {
        id: pageLoader
        anchors.fill: parent
        sourceComponent: mainPage
    }

    Component {
        id: mainPage

        Item {
            id: root
            anchors.fill: parent

            // Define base resolution
            property int baseWidth: 1920
            property int baseHeight: 1080

            // Container that scales its content
            Item {
                id: scaleWrapper
                width: baseWidth
                height: baseHeight
                anchors.centerIn: parent
                scale: Math.min(root.width / baseWidth, root.height / baseHeight)

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
        }
    }
}
