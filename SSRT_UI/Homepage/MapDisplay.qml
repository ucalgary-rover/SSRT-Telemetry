// MapDisplay.qml
import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick.Controls 2.15
import com.example 1.0
import SSRTelemetry

Item {
    id: mapDisplay
    width: parent ? parent.width : 800
    height: parent ? parent.height : 600

    // Internal properties
    property bool startSet: false
    property var startCoord: QtPositioning.coordinate(0, 0)

    // Internal component instances
    LabelManager {
        id: labelManager
    }

    RoverTracker {
        id: roverTracker
        onPositionChanged: {
            if (!mapDisplay.startSet) {
                mapDisplay.startCoord = QtPositioning.coordinate(roverTracker.latitude, roverTracker.longitude);
                mapDisplay.startSet = true;
                console.log("Start point set at", roverTracker.latitude, roverTracker.longitude);
            }
        }
    }

    RoverMQTT {
        id: mqttClient
        onStatusChanged: {
            console.log("MQTT Status:", status);
            if (status === "Connected") {
                mqttClient.subscribeTopic("rover/sensor");
            }
        }
        onMessageReceived: {
            console.log("Received Message on", topic, ":", message);
        }
        Component.onCompleted: {
            mqttClient.connectToBroker("localhost", 1883);
        }
    }

    // The Map and its children.
    Map {
        id: map
        anchors.fill: parent

        plugin: Plugin {
            name: "osm"
            PluginParameter {
                name: "osm.mapping.providersrepository.address"
                value: "https://tile.thunderforest.com/landscape/{z}/{x}/{y}.png?apikey=636ab8ae26aa43588f5c914d74ca747a"
            }
            PluginParameter {
                name: "osm.mapping.providersrepository.enabled"
                value: true
            }
        }
        zoomLevel: 15

        // Start point marker.
        MapQuickItem {
            id: startPointMarker
            visible: mapDisplay.startSet
            coordinate: mapDisplay.startCoord
            anchorPoint.x: startIcon.width / 2
            anchorPoint.y: startIcon.height / 2
            sourceItem: Rectangle {
                id: startIcon
                width: 20
                height: 20
                color: "green"
                radius: 10
                border.color: "black"
                border.width: 1
            }
        }

        // Center the map on the rover's current position.
        center: roverTracker ? QtPositioning.coordinate(roverTracker.latitude, roverTracker.longitude) : QtPositioning.coordinate(0, 0)

        // Rover marker.
        MapQuickItem {
            anchorPoint.x: 10
            anchorPoint.y: 10
            coordinate: roverTracker ? QtPositioning.coordinate(roverTracker.latitude, roverTracker.longitude) : QtPositioning.coordinate(0, 0)
            sourceItem: Rectangle {
                width: 20
                height: 20
                color: "blue"
                radius: 10
            }
        }

        // Display map labels using MapItemView.
        MapItemView {
            id: labelView
            model: labelManager.allLabels()
            delegate: MapQuickItem {
                coordinate: QtPositioning.coordinate(modelData.latitude, modelData.longitude)
                anchorPoint.x: labelDot.width / 2
                anchorPoint.y: labelDot.height / 2
                sourceItem: Rectangle {
                    id: labelDot
                    width: 20
                    height: 20
                    radius: 10
                    color: modelData.getColour()
                }
            }
        }

        // Update the MapItemView model when labels are updated.
        Connections {
            target: labelManager
            onLabelsUpdated: {
                labelView.model = labelManager.allLabels();
                console.log("labelsUpdated fired, count:", labelManager.labelCount);
            }
        }

        // Distance indicator.
        Text {
            id: distanceText
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.margins: 10
            color: "black"
            font.pixelSize: 16
            text: {
                if (!mapDisplay.startSet) {
                    return "Start not set";
                }
                var currentCoord = roverTracker ? QtPositioning.coordinate(roverTracker.latitude, roverTracker.longitude) : QtPositioning.coordinate(0, 0);
                var d = currentCoord.distanceTo(mapDisplay.startCoord);
                return "Distance: " + d.toFixed(2) + " m";
            }
        }

        // --- Filter and Add Controls Container ---
        Rectangle {
            id: controlPanelTest
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 10
            width: 250
            height: 190 // addLabels.menuData[addLabels.dropdownCol.selectedTop].length > 0 ? 190 : 150
            color: "#cba87f"
            border.color: "black"
            radius: 5
            z: 1

            Column {
                id: menuColumn
                spacing: 10
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "Label Controls"
                    font.bold: true
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                }

                TwoTieredDropdown {
                    id: addLabels
                    defaultSelect: "O3"
                    buttonText: "Add"
                    menuData: labelManager.getAllLabels()
                    onButtonAction: {
                        if (labelManager) {
                            var labelList;
                            if (menuData[addLabels.selectedTop].length === 0) {
                                labelList = [addLabels.selectedTop, ""];
                            }
                            else {
                                labelList = [addLabels.selectedTop, addLabels.selectedLower];
                            }


                            labelManager.addLabel(map.center.latitude, map.center.longitude, labelList);
                        }
                    }
                }

                // Filtering controls.
                Text {
                    text: "Filter Labels:"
                    font.bold: true
                    color: "black"
                }
                Row {
                    spacing: 10
                    ComboBox {
                        id: filterDropdownMenu
                        height: 40
                        currentIndex: 0
                        model: ["All", "Poison", "Toxic", "Physical", "Damaged Line", "Ozone", "POI", "Hydrogen", "Damaged Rod", "Reactor"]

                        onActivated: {
                            console.log("current value: ", currentValue);
                            if (currentValue === "All" && labelManager) {
                                labelView.model = labelManager.allLabels();
                            } else if (labelManager) {
                                var label_type = labelManager.createDummyMapLabel().type_from_str(currentValue);
                                labelView.model = labelManager.filterLabels(label_type);
                            }
                        }
                    }

                    Button {
                        id: saveTxt
                        text: "Save Text"
                        width: 100
                        height: 40
                        background: Rectangle {
                            anchors.fill: parent
                            color: "#c85428"
                            radius: 4
                        }
                        font.pixelSize: 12
                        font.bold: true
                        onClicked: {
                            if (labelManager) {
                                labelManager.saveToTxt();
                            }
                        }
                    }
                }
            }
        }
        // --- End of Control Panel ---
    } // End of Map

    component TwoTieredDropdown: Row {
        id: twoTieredDropdown

        property alias buttonText: button.text
        signal buttonAction
        property string defaultSelect
        property var menuData
        property alias selectedTop: dropdownCol.selectedTop
        property alias selectedLower: dropdownCol.selectedLower

        spacing: 10

        Column {
            id: dropdownCol
            height: 40

            property string selectedTop: parent.defaultSelect
            property string selectedLower: ""

            onSelectedTopChanged: parent.selectedTop = selectedTop
            onSelectedLowerChanged: parent.selectedLower = selectedLower

            // parent dropdown
            ComboBox {
                id: topDropdown
                height: 40

                property var keys: Object.keys(parent.parent.menuData)
                model: keys
                currentIndex: keys.indexOf(parent.selectedTop)

                onActivated: {
                    parent.selectedTop = currentValue;
                }
            }

            // child dropdown
            ComboBox {
                id: lowerDropdown
                height: 40
                currentIndex: 0
                visible: parent.parent.menuData[parent.selectedTop].length > 0

                model: parent.selectedTop !== "" ? parent.parent.menuData[parent.selectedTop] : []

                onActivated: {
                    parent.selectedLower = currentValue;
                }
            }
        }

        Button {
            id: button
            width: 100
            height: 40
            background: Rectangle {
                anchors.fill: parent
                color: "#c85428"
                radius: 4
            }

            font.pixelSize: 12
            font.bold: true

            onClicked: parent.buttonAction()
        }
    }
}
