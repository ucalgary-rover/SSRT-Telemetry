// MapDisplay.qml
import QtQuick 2.15
import QtLocation 5.15
import QtPositioning 5.15
import QtQuick.Controls 2.15
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
        zoomLevel: 18
        minimumZoomLevel: 15
        maximumZoomLevel: 20
        property bool centerChanged: false;

        onCenterChanged: {
            console.log("Changed center");
            console.log("new center " + center);
            if(center !== QtPositioning.coordinate(0, 0)){
                centerChanged = true;
                console.log("new center " + center);
            }
        }

        // handle mouse scrolls
        WheelHandler {
            id: wheelHandler
            property real zoomStep: 0.5

            onWheel: (event) => {
                const direction = event.angleDelta.y > 0 ? 1: -1
                const newZoom = target.zoomLevel + direction * zoomStep
                parent.zoomLevel = Math.max(target.minimumZoomLevel, Math.min(target.maximumZoomLevel, newZoom))
            }
        }

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

                MouseArea {
                    id: startMarkerMouseArea
                    anchors.fill: parent
                    hoverEnabled: true

                    ToolTip.visible: containsMouse
                    ToolTip.delay: 0
                    ToolTip.text: "Start Point\nLat: " + mapDisplay.startCoord.latitude + "    Lon: " + mapDisplay.startCoord.longitude
                }
            }
        }

        // Center the map on the rover's current position.
        center: {
            if(!centerChanged) return roverTracker ? QtPositioning.coordinate(roverTracker.latitude, roverTracker.longitude) : QtPositioning.coordinate(0, 0);

            var roverCoord = QtPositioning.coordinate(roverTracker.latitude, roverTracker.longitude);
            var roverScreenPos = map.fromCoordinate(roverCoord);

            var insideBoundary =
                    roverScreenPos.x >= roverBoundarySpace.x && //left bound
                    roverScreenPos.x < roverBoundarySpace.x + roverBoundarySpace.width && //right bound
                    roverScreenPos.y >= roverBoundarySpace.y && //bottom bound
                    roverScreenPos.y < roverBoundarySpace.y + roverBoundarySpace.height; //top bound

            if(!insideBoundary) {
                return roverCoord;
            }

            return center;
        }

        // region rover can move within before changing map position
        Rectangle {
            id: roverBoundarySpace
            width: parent.width * 0.7
            height: parent.height * 0.7

            anchors.horizontalCenter:  parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            color: "red"
            opacity: 0.5
        }

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

                    MouseArea {
                        id: markerMouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        ToolTip.visible:  containsMouse
                        ToolTip.delay: 0
                        ToolTip.text: {
                            var subtype = (modelData.type && modelData.type.length > 1 && modelData.type[1].length > 0)
                                    ? (modelData.type[0] + " / " + modelData.type[1])
                                    : modelData.type[0];
                           subtype +"\nLat: " + modelData.latitude.toFixed(6) + "    Lon: " + modelData.longitude.toFixed(6)

                        }}
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
            height: addLabels.menuData[addLabels.selectedTop].length > 1 ? 190 : 150
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
                    id: headingText
                    text: "Label Controls"
                    font.bold: true
                    color: "black"
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    anchors.top: parent.top
                }

                TwoTieredDropdown {
                    id: addLabels
                    defaultSelect: "O3"
                    buttonText: "Add"
                    menuData: labelManager.getAllLabels()
                    anchors.top: headingText.bottom
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
                    id: filterText
                    text: "Filter Labels:"
                    font.bold: true
                    color: "black"
                    anchors.top: addLabels.bottom
                    anchors.topMargin: 10
                }

                Row {
                    spacing: 10
                    anchors.top: filterText.bottom
                    ComboBox {
                        id: filterLabels
                        height: 40
                        currentIndex: 0
                        model: {
                            var labels = Object.keys(labelManager.getAllLabels());
                            labels.unshift("All");
                            return labels;
                        }

                        onActivated: {
                            console.log("current value: ", currentValue);
                            if (currentValue === "All" && labelManager) {
                                labelView.model = labelManager.allLabels();
                            } else if (labelManager) {
                                labelView.model = labelManager.filterLabels(currentValue);
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
        }
        // --- End of Control Panel ---
     // End of Map

    component TwoTieredDropdown: Row {
        id: twoTieredDropdown

        property alias buttonText: button.text
        signal buttonAction
        property string defaultSelect
        property var menuData
        property alias selectedTop: dropdownCol.selectedTop
        property alias selectedLower: dropdownCol.selectedLower

        height: menuData[selectedTop].length > 1 ? 80 : 40

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

                    if (parent.parent.menuData[currentValue].length > 1) {
                        parent.selectedLower = "CL-D";
                    }
                    else {
                        parent.selectedLower = "";
                    }
                }
            }

            // child dropdown
            ComboBox {
                id: lowerDropdown
                height: 40
                currentIndex: 0
                visible: parent.parent.menuData[parent.selectedTop].length > 1

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
