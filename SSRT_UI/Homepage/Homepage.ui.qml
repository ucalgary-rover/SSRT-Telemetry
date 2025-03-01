import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "../Components"
import "../"
import "../assets"
import "../AddtionalUIComponents/"

Rectangle {
    id: homepage
    width: 1920
    height: 1080 - 150
    color: "transparent"

    MapDisplay {
        width: 1415
    }

    Image {
        id: date_2024_10_22_11_14_51_Sensor_A_N_A_Sensor_B_N_A_Sensor_C_N_A
        visible: false
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1454
        anchors.topMargin: 649
        source: "../assets/date_2024_10_22_11_14_51_Sensor_A_N_A_Sensor_B_N_A_Sensor_C_N_A.png"
    }

    Rectangle {
        id: rectangle
        width: 5
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: 500
        color: "#7b664c"
    }

    Rectangle {
        id: horizontal_Full_width
        width: 505
        height: 4
        color: "#7b664c"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1415
        anchors.topMargin: 441
    }

    RoverAngleDisplay {
        id: roverAngle
        width: 500
        height: 1000
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        warningAngleThreshold: 45
    }
}

/*##^##
Designer {
    D{i:0;uuid:"f352e9d5-2ef1-5fd8-be81-4de3298f38bc"}
}
##^##*/
