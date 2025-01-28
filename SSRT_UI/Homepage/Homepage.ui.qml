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

    // Application_Layout {
    //     id: application_Layout
    //     width: 1920
    //     height: 1080
    //     anchors.left: parent.left
    //     anchors.top: parent.top
    //     state: "property_1_Telemetry"
    // }
    Rectangle {
        id: map_frame
        width: 1322
        height: 855
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 49
        anchors.topMargin: 45
        Image {
            id: map
            anchors.left: parent.left
            anchors.top: parent.top
            source: "../assets/map.png"
        }

        Rectangle {
            id: rectangle_1
            width: 1322
            height: 72
            color: "#d4c4b5"
            anchors.left: parent.left
            anchors.top: parent.top
        }

        Image {
            id: latitude_38_8951_Longitude_77_0364_Speed_10km_hr
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 139
            anchors.topMargin: 23
            source: "../assets/latitude_38_8951_Longitude_77_0364_Speed_10km_hr.png"
        }

        // Car {
        //     id: car
        //     width: 62
        //     height: 61
        //     anchors.left: parent.left
        //     anchors.top: parent.top
        //     anchors.leftMargin: 750
        //     anchors.topMargin: 544
        // }

        // Compass_Navigator {
        //     id: compass_Navigator
        //     width: 74
        //     height: 92
        //     anchors.left: parent.left
        //     anchors.top: parent.top
        //     anchors.leftMargin: 1203
        //     anchors.topMargin: 102
        //     clip: true
        // }
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
    }
}

/*##^##
Designer {
    D{i:0;uuid:"f352e9d5-2ef1-5fd8-be81-4de3298f38bc"}
}
##^##*/
