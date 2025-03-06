import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import SSRTelemetry

ColumnLayout {
    id: scienceSensorDisplay

    ScienceSensors {
        id: scienceSensorData
    }

    // component for a single sensor display
    component SingleDisplay: Rectangle {
        id: singleDisplay

        property alias name: sensorName.text
        property alias value: sensorValue.text

        Layout.preferredHeight: parent.height / scienceSensorDisplay.children.length   // evenly split height between children
        color: "transparent"

        RowLayout {
            Text {
                id: sensorName
            }

            Text {
                id: sensorValue
            }
        }

    }

    // decay coefficient
    SingleDisplay {
        name: qsTr("Decay Coefficient")
        value: scienceSensorData.decay_coeff
    }

    // half life
    SingleDisplay {
        name: qsTr("Half Life")
        value: scienceSensorData.half_life
    }

    // total energy
    SingleDisplay {
        name: qsTr("Total Energy")
        value: scienceSensorData.total_energy
    }

    // uncertainty
    SingleDisplay {
        name: qsTr("Uncertainty")
        value: scienceSensorData.uncertainty
    }

    // ozone ppm
    SingleDisplay {
        name: qsTr("Ozone PPM")
        value: scienceSensorData.ozone_ppm
    }

    // h2 ppm
    SingleDisplay {
        name: qsTr("H2 PPM")
        value: scienceSensorData.h2_ppm
    }

    // atomic radius
    SingleDisplay {
        name: qsTr("Atomic Radius")
        value: scienceSensorData.atomic_radius
    }

    // radioactivity
    SingleDisplay {
        name: qsTr("Radioactivity")
        value: scienceSensorData.radioactivity
    }
}
