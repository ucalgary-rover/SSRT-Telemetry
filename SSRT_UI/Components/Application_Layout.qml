import "../"
import "../AddtionalUIComponents/"
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.0

Rectangle {
    id: application_Layout
    width: 1920
    height: 150
    color: "#f3d5b5"
    state: "property_1_Telemetry"
    property alias sSRTText: sSRT.text

    signal telemetryClicked()
    signal cameraClicked()

    Rectangle {
        id: navigation_Bar
        width: 1920
        height: 125
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 14

        Rectangle {
            id: rectangle
            anchors.left: parent.left
            anchors.top: parent.bottom
            width: 1920
            height: 5
            color: "#7b664c"
        }

        Image {
            id: sSRT_Logo
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 16
            source: "../assets/sSRT_Logo_property_1_Telemetry.png"
        }

        Text {
            id: sSRT
            width: 199
            height: 78
            color: "#390c00"
            text: qsTr("SSRT")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 148
            anchors.topMargin: 22
            font.pixelSize: 64
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignTop
            wrapMode: Text.Wrap
            font.weight: Font.Normal
            font.family: "Coda"
        }

        Rectangle {
            id: tabs
            width: 686
            height: 81
            color: "transparent"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 326
            anchors.topMargin: 22

            TabBar {
                id: tabBar
                anchors.left: parent.left
                anchors.top: parent.top
                width: parent.width
                height: parent.height
                Layout.fillWidth: true
                Layout.fillHeight: true

                TabButton {
                    id: telemetryTabButton
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    text: qsTr("Telemetry")

                    contentItem: Text {
                        id: telemetryLabel
                        color: "#390c00"
                        text: qsTr("Telemetry")
                        font.pixelSize: 36
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 44
                        lineHeightMode: Text.FixedHeight
                        wrapMode: Text.NoWrap
                        font.weight: Font.Normal
                        font.family: "Roboto"
                        Layout.preferredWidth: 160
                        Layout.preferredHeight: 44
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    background: Rectangle {
                        id: telemetrytab
                        color: "#f3d5b5"
                    }

                    onClicked: telemetryClicked()
                }

                TabButton {
                    id: camerabutton
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    //anchors.topMargin: 0
                    text: qsTr("Camera")
                    contentItem: Text {
                        id: cameraLabel
                        color: "#390c00"
                        text: qsTr("Camera")
                        font.pixelSize: 36
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        lineHeight: 44
                        lineHeightMode: Text.FixedHeight
                        wrapMode: Text.NoWrap
                        font.weight: Font.Normal
                        font.family: "Roboto"
                        Layout.preferredWidth: 160
                        Layout.preferredHeight: 44
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    background: Rectangle {
                        id: cameratab
                        color: "#f3d5b5"
                    }

                    onClicked: cameraClicked()
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;uuid:"28a23d57-43a4-5536-aa77-f4b2ebb12526"}D{i:1;uuid:"0d441f4f-8359-5b48-9098-37b3b5917479"}
D{i:3;uuid:"1bcd6948-c2d2-5027-a951-661e4e7dc291"}D{i:4;uuid:"b68e0648-37da-5d7d-bcc6-14c18df66d1f"}
}
##^##*/
