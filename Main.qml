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

                Connections {
                    target: RoverMQTT
                    function onMessageReceived(topic, message) {
                        console.log("IN MESSAGE RECEIVED");
                        var data = JSON.parse(message);
                        console.log("Raw JSON data: ", data);
                        if (data.lat !== undefined && data.lon !== undefined) {
                            RoverTracker.setCoordinate(data.lat, data.lon);
                        }

                        if (data.h2_1 !== undefined) {
                            ScienceSensors.setH21PPM(data.h2_1);
                        }

                        if (data.h2_2 !== undefined) {
                            ScienceSensors.setH22PPM(data.h2_1);
                        }

                        if (data.ozone !== undefined) {
                            ScienceSensors.setOzonePPM(data.ozone);
                        }
                    }

                    // connect to the broker and susbscribe to the topic once on startup
                    //Component.onCompleted: {
                    //    console.log("i AM HERE");
                    //    RoverMQTT.connectToBroker("192.168.1.100", 1883);    // replace with host name and port
                    //    RoverMQTT.subscribeTopic("sensors/sensor_1");     // replaced with actual topic name
                    //}
                }

                Timer {
                    id: delayTimer
                    interval: 5000    // milliseconds (1 second)
                    repeat: false
                    onTriggered: {
                        RoverMQTT.subscribeTopic("sensors_1");
                    }
                }

                // Connections for handling nav bar signals
                Connections {
                    target: navLoader.item
                    function onTelemetryClicked() {
                        pageLoader.source = "qrc:/SSRT_UI/Homepage/BasePage.qml";
                    }
                    function onCameraClicked() {
                        pageLoader.source = "qrc:/SSRT_UI/CameraPage/CameraPage.qml";
                    }
                }
            }
        }
    }
}
