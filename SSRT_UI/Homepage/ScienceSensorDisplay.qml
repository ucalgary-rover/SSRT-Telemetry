import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import SSRTelemetry

ColumnLayout {
    id: scienceSensorDisplay

    // ScienceSensors {
    //     id: scienceSensorData
    // }

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
                font.bold: true
                font.pointSize: 16
            }

            Text {
                text: qsTr(":")
                font.bold: true
                font.pointSize: 16
            }

            Text {
                id: sensorValue
                font.pointSize: 16
            }
        }

    }

    // decay coefficient
    SingleDisplay {
        name: qsTr("Decay Coeff")
        value: ScienceSensors.decay_coeff
    }

    // half life
    SingleDisplay {
        name: qsTr("Half Life")
        value: ScienceSensors.half_life
    }

    // total energy
    SingleDisplay {
        name: qsTr("Total Energy")
        value: ScienceSensors.total_energy
    }

    // uncertainty
    SingleDisplay {
        name: qsTr("Uncertainty")
        value: ScienceSensors.uncertainty
    }

    // ozone ppm
    SingleDisplay {
        name: qsTr("Ozone PPM")
        value: ScienceSensors.ozone_ppm
    }

    // h2 ppm
    SingleDisplay {
        name: qsTr("H2 PPM #1")
        value: ScienceSensors.h2_1_ppm
    }

    // h2 ppm
    SingleDisplay {
        name: qsTr("H2 PPM #2")
        value: ScienceSensors.h2_2_ppm
    }

    // // atomic radius
    // SingleDisplay {
    //     name: qsTr("Atomic Radius")
    //     value: ScienceSensors.atomic_radius
    // }

    // radioactivity
    SingleDisplay {
        name: qsTr("Radioactivity")
        value: ScienceSensors.radioactivity
    }
}
