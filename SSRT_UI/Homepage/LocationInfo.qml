import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    id: locationRow
    anchors.fill: parent
    spacing: 1
    Layout.fillHeight: true
    Layout.fillWidth: true
    anchors.margins: 10
    Layout.margins: 5
    property var coordinate
    property var mouseCoordinate

    component LocationDisplay: Rectangle {
        id: locationDisplay

        property alias name: locationName.text
        property alias value: locationValue.text

        Layout.preferredHeight: parent.height / locationRow.children.length   // evenly split height between children
        color: "transparent"

        ColumnLayout {
            RowLayout {
                Text {
                    id: locationName
                    font.bold: true
                    font.pointSize: 12
                }
                Text {
                    id: locationValue
                    font.pointSize: 12
                }
            }
        }
    }

    LocationDisplay {
        Layout.preferredWidth: 1.5
        name: qsTr("Rover Coordinates: ")
        value: locationRow.coordinate
    }

    // LocationDisplay {
    //     Layout.preferredWidth: 1.5
    //     name: qsTr("Coordinates: ")
    //     value: locationRow.mouseCoordinate
    // }

    LocationDisplay {
        name: qsTr("Direction: ")
        value: "Direction"
    }

    LocationDisplay {
        name: qsTr("Speed: ")
        value: "20"
    }
}

