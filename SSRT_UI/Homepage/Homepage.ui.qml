import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import "../Components"
import "../"

Rectangle {
    id: homepage
    width: 1920
    height: 1080
    color: "transparent"

    Application_Layout {
        id: application_Layout
        width: 1920
        height: 1080
        anchors.left: parent.left
        anchors.top: parent.top
        state: "property_1_Telemetry"
    }

    Rectangle {
        id: map_frame
        width: 1322
        height: 855
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 49
        anchors.topMargin: 183
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

        Car {
            id: car
            width: 62
            height: 61
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 750
            anchors.topMargin: 544
        }

        Compass_Navigator {
            id: compass_Navigator
            width: 74
            height: 92
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 1203
            anchors.topMargin: 102
            clip: true
        }
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

    Vertical_Inset {
        id: vertical_Inset
        width: 57
        height: 955
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1399
        anchors.topMargin: 125
        clip: true
    }

    Horizontal_Full_width {
        id: horizontal_Full_width
        width: 489
        height: 102
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 1431
        anchors.topMargin: 540
    }
}

/*##^##
Designer {
    D{i:0;uuid:"f352e9d5-2ef1-5fd8-be81-4de3298f38bc"}D{i:1;uuid:"17f1a76f-98ab-541f-8413-d257c1b35204"}
D{i:2;uuid:"cb9ed074-fadf-5fad-92fc-2db07e1dd286"}D{i:3;uuid:"f6acfcdc-28d3-5c86-bb40-0c9fe3bc5e92"}
D{i:4;uuid:"d68f9a88-6a55-5820-a359-6196d94d61ab"}D{i:5;uuid:"8f7e637a-40b4-5440-9d4b-f6b28ee8c8f8"}
D{i:6;uuid:"559edbe7-208b-59ac-8edc-e8ad6c2ba291"}D{i:7;uuid:"58cd3172-447e-5ffc-b199-839a239307cb"}
D{i:8;uuid:"f4c9c491-65ef-5605-a98a-0ed235737673"}D{i:9;uuid:"3ee6ab6a-334b-5b41-b7ab-876a31b67477"}
D{i:10;uuid:"5fd512a2-b917-5078-a09d-dde558d89ffc"}
}
##^##*/

