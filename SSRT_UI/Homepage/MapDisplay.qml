import QtQuick
import QtLocation 5.15
import QtPositioning 5.15

Map {
    id: map
    width: parent.width * 0.75
    height: parent.height
    anchors.left: parent.left

    plugin: Plugin {
        name: "osm"
        PluginParameter {
            name: "osm.mapping.providersrepository.address"
            value: "https://tile.thunderforest.com/landscape/{z}/{x}/{y}.png?apikey=636ab8ae26aa43588f5c914d74ca747a"
        }
        PluginParameter { name: "osm.mapping.providersrepository.enabled"; value: true }
    }
    zoomLevel: 15

    // Center the map on the rover's position
    center: QtPositioning.coordinate(roverTracker.latitude, roverTracker.longitude)

    // Rover marker
    MapQuickItem {
        anchorPoint.x: 10
        anchorPoint.y: 10
        coordinate: QtPositioning.coordinate(roverTracker.latitude, roverTracker.longitude)
        sourceItem: Rectangle {
            width: 20
            height: 20
            color: "blue"
            radius: 10
        }
    }
}
