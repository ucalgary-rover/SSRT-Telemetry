import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Studio.Components 1.0
import QtQuick.Shapes 1.0
import QtQuick.Layouts 1.15
import "../"
import "../AddtionalUIComponents/"

Rectangle {
    id: application_Layout
    width: 1920
    height: 1080
    color: "#f3d5b5"
    property alias sSRTText: sSRT.text
    property alias label1Text: label1.text
    property alias labelText: label.text
    state: "property_1_Telemetry"

    Rectangle {
        id: navigation_Bar
        width: 1920
        height: 125
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 14
        SvgPathItem {
            id: line_1_Stroke_
            width: 1920
            height: 5
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 123
            strokeWidth: 5
            strokeStyle: 1
            strokeColor: "transparent"
            path: "M 1920 5 L 0 5 L 0 0 L 1920 0 L 1920 5 Z"
            joinStyle: 0
            fillColor: "#7b664c"
            antialiasing: true
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
            ColumnLayout {
                id: tabs_layout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: 0
                Rectangle {
                    id: tab_group
                    x: 0
                    y: 0
                    width: 686
                    height: 80
                    color: "transparent"
                    RowLayout {
                        id: tab_group_layout
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        spacing: 0
                        Rectangle {
                            id: tab_1
                            x: 0
                            y: 0
                            width: 343
                            height: 80
                            color: "#f3d5b5"
                            ColumnLayout {
                                id: tab_1_layout
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                spacing: 0
                                Rectangle {
                                    id: state_layer
                                    x: 0
                                    y: 0
                                    width: 343
                                    height: 80
                                    color: "transparent"
                                    RowLayout {
                                        id: state_layer_layout
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.leftMargin: 16
                                        anchors.rightMargin: 16
                                        spacing: 0
                                        Item {
                                            id: state_layer_QtQuick_Layouts_RowLayout_SpacerFrontal
                                            x: 0
                                            y: 0
                                            width: 1
                                            height: 1
                                            Layout.fillWidth: true
                                        }

                                        Rectangle {
                                            id: tab_Contents
                                            x: 92
                                            y: 0
                                            width: 159
                                            height: 80
                                            color: "transparent"
                                            ColumnLayout {
                                                id: tab_Contents_layout
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.topMargin: 10
                                                anchors.bottomMargin: 8
                                                spacing: 2
                                                Item {
                                                    id: tab_Contents_QtQuick_Layouts_ColumnLayout_SpacerFrontal
                                                    x: 0
                                                    y: 0
                                                    width: 1
                                                    height: 1
                                                    Layout.fillHeight: true
                                                }

                                                Rectangle {
                                                    id: icon_badge
                                                    x: 68
                                                    y: 6
                                                    width: 24
                                                    height: 24
                                                    color: "transparent"
                                                    Location_on {
                                                        id: icon
                                                        width: 24
                                                        height: 24
                                                        anchors.left: parent.left
                                                        anchors.top: parent.top
                                                        clip: true
                                                    }

                                                    Badges {
                                                        id: badges
                                                        width: 6
                                                        height: 6
                                                        visible: false
                                                        anchors.left: parent.left
                                                        anchors.top: parent.top
                                                        anchors.leftMargin: 18
                                                        state: "size_Small"
                                                    }
                                                    Layout.preferredWidth: 24
                                                    Layout.preferredHeight: 24
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                }

                                                Text {
                                                    id: label
                                                    x: 0
                                                    y: 32
                                                    width: 160
                                                    height: 44
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
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                }

                                                Item {
                                                    id: tab_Contents_QtQuick_Layouts_ColumnLayout_SpacerRear
                                                    x: 0
                                                    y: 0
                                                    width: 1
                                                    height: 1
                                                    Layout.fillHeight: true
                                                }
                                            }

                                            Rectangle {
                                                id: indicator
                                                height: 6
                                                color: "transparent"
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                anchors.bottom: parent.bottom
                                                Image {
                                                    id: shape
                                                    anchors.left: parent.left
                                                    anchors.right: parent.right
                                                    anchors.bottom: parent.bottom
                                                    anchors.leftMargin: 2
                                                    anchors.rightMargin: 2
                                                    source: "../assets/shape_property_1_Telemetry.png"
                                                }
                                            }
                                            Layout.preferredWidth: 159
                                            Layout.fillHeight: true
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }

                                        Item {
                                            id: state_layer_QtQuick_Layouts_RowLayout_SpacerRear
                                            x: 0
                                            y: 0
                                            width: 1
                                            height: 1
                                            Layout.fillWidth: true
                                        }
                                    }
                                    clip: true
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                }
                            }
                            clip: true
                            Layout.preferredHeight: 80
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }

                        Rectangle {
                            id: tab_2
                            x: 343
                            y: 0
                            width: 343
                            height: 80
                            color: "#f3d5b5"
                            ColumnLayout {
                                id: tab_2_layout
                                anchors.left: parent.left
                                anchors.right: parent.right
                                anchors.top: parent.top
                                anchors.bottom: parent.bottom
                                spacing: 0
                                Rectangle {
                                    id: state_layer1
                                    x: 0
                                    y: 0
                                    width: 343
                                    height: 80
                                    color: "transparent"
                                    RowLayout {
                                        id: state_layer_layout1
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.bottom: parent.bottom
                                        anchors.leftMargin: 16
                                        anchors.rightMargin: 16
                                        spacing: 0
                                        Rectangle {
                                            id: tab_Contents1
                                            x: 16
                                            y: 0
                                            width: 311
                                            height: 80
                                            color: "transparent"
                                            ColumnLayout {
                                                id: tab_Contents_layout1
                                                anchors.left: parent.left
                                                anchors.right: parent.right
                                                anchors.top: parent.top
                                                anchors.bottom: parent.bottom
                                                anchors.topMargin: 10
                                                anchors.bottomMargin: 8
                                                spacing: 2
                                                Item {
                                                    id: tab_Contents_QtQuick_Layouts_ColumnLayout_SpacerFrontal1
                                                    x: 0
                                                    y: 0
                                                    width: 1
                                                    height: 1
                                                    Layout.fillHeight: true
                                                }

                                                Rectangle {
                                                    id: icon_badge1
                                                    x: 144
                                                    y: 6
                                                    width: 24
                                                    height: 24
                                                    color: "transparent"
                                                    Videocam {
                                                        id: icon1
                                                        width: 24
                                                        height: 24
                                                        anchors.left: parent.left
                                                        anchors.top: parent.top
                                                        clip: true
                                                    }

                                                    Badges {
                                                        id: badges1
                                                        width: 6
                                                        height: 6
                                                        visible: false
                                                        anchors.left: parent.left
                                                        anchors.top: parent.top
                                                        anchors.leftMargin: 18
                                                        state: "size_Small"
                                                    }
                                                    Layout.preferredWidth: 24
                                                    Layout.preferredHeight: 24
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                }

                                                Text {
                                                    id: label1
                                                    x: 93
                                                    y: 32
                                                    width: 126
                                                    height: 44
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
                                                    Layout.preferredWidth: 126
                                                    Layout.preferredHeight: 44
                                                    Layout.alignment: Qt.AlignHCenter
                                                                      | Qt.AlignVCenter
                                                }

                                                Item {
                                                    id: tab_Contents_QtQuick_Layouts_ColumnLayout_SpacerRear1
                                                    x: 0
                                                    y: 0
                                                    width: 1
                                                    height: 1
                                                    Layout.fillHeight: true
                                                }
                                            }
                                            Layout.preferredHeight: 80
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                        }
                                    }
                                    clip: true
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                                }
                            }
                            clip: true
                            Layout.preferredHeight: 80
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }
                    }

                    Rectangle {
                        id: indicator1
                        visible: false
                        color: "transparent"
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.leftMargin: 435
                        anchors.rightMargin: 92
                        anchors.topMargin: 73
                        anchors.bottomMargin: 1
                        Image {
                            id: shape1
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 2
                            anchors.rightMargin: 2
                            source: "../assets/shape_property_1_Camera.png"
                        }
                    }
                    Layout.preferredHeight: 80
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                }

                Item {
                    id: tabs_QtQuick_Layouts_ColumnLayout_SpacerRear
                    x: 0
                    y: 0
                    width: 1
                    height: 1
                    Layout.fillHeight: true
                }
            }
        }
    }
    states: [
        State {
            name: "property_1_Telemetry"

            PropertyChanges {
                target: indicator
                visible: true
            }

            PropertyChanges {
                target: sSRT_Logo
                source: "../assets/sSRT_Logo_property_1_Telemetry.png"
            }

            PropertyChanges {
                target: indicator1
                visible: false
            }
        },
        State {
            name: "property_1_Camera"

            PropertyChanges {
                target: indicator
                visible: false
            }

            PropertyChanges {
                target: sSRT_Logo
                source: "../assets/sSRT_Logo_property_1_Camera.png"
            }

            PropertyChanges {
                target: indicator1
                visible: true
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;uuid:"28a23d57-43a4-5536-aa77-f4b2ebb12526"}D{i:1;uuid:"0d441f4f-8359-5b48-9098-37b3b5917479"}
D{i:2;uuid:"6e244e07-c30b-5ae5-b724-51557800e7ad"}D{i:3;uuid:"1bcd6948-c2d2-5027-a951-661e4e7dc291"}
D{i:4;uuid:"b68e0648-37da-5d7d-bcc6-14c18df66d1f"}D{i:5;uuid:"5b15a34f-c58c-5eb5-9325-71435157b51e"}
D{i:6;uuid:"5b15a34f-c58c-5eb5-9325-71435157b51e_VERTICAL"}D{i:7;uuid:"1b679ec4-4ff1-5865-bcce-46d5d6f49308"}
D{i:8;uuid:"1b679ec4-4ff1-5865-bcce-46d5d6f49308_HORIZONTAL"}D{i:9;uuid:"695d0fe7-03f1-5004-9405-169b1ee9b577"}
D{i:10;uuid:"695d0fe7-03f1-5004-9405-169b1ee9b577_VERTICAL"}D{i:11;uuid:"30dbe022-274c-59f3-821a-5e840a2ccb7f"}
D{i:12;uuid:"30dbe022-274c-59f3-821a-5e840a2ccb7f_HORIZONTAL"}D{i:13;uuid:"30dbe022-274c-59f3-821a-5e840a2ccb7f_HORIZONTAL_SpacerFrontal"}
D{i:14;uuid:"334bbdc8-f94b-57a9-b2f1-19b7b151177f"}D{i:15;uuid:"334bbdc8-f94b-57a9-b2f1-19b7b151177f_VERTICAL"}
D{i:16;uuid:"334bbdc8-f94b-57a9-b2f1-19b7b151177f_VERTICAL_SpacerFrontal"}D{i:17;uuid:"50382bbe-4a26-536b-869b-d93446837130"}
D{i:18;uuid:"0a0f6a5b-5870-5bd9-a87c-8386712a32a6"}D{i:19;uuid:"87c283a0-719c-50e1-8266-a1e72a5403d0"}
D{i:20;uuid:"77669af4-98cc-5d0b-ac89-62efaf76f1b0"}D{i:21;uuid:"334bbdc8-f94b-57a9-b2f1-19b7b151177f_VERTICAL_SpacerRear"}
D{i:22;uuid:"3ce3128e-b4fe-55d9-88ea-d357c2fba70b"}D{i:23;uuid:"b3750724-4eaa-5c31-a0f6-602cb9fbcf74"}
D{i:24;uuid:"30dbe022-274c-59f3-821a-5e840a2ccb7f_HORIZONTAL_SpacerRear"}D{i:25;uuid:"45452069-f9b3-59ac-b3bb-9466e469817f"}
D{i:26;uuid:"45452069-f9b3-59ac-b3bb-9466e469817f_VERTICAL"}D{i:27;uuid:"42153507-5ca5-5e91-9ed1-91150e9054c7"}
D{i:28;uuid:"42153507-5ca5-5e91-9ed1-91150e9054c7_HORIZONTAL"}D{i:29;uuid:"e051fbf1-e727-5e4c-bfa7-e058e58499c0"}
D{i:30;uuid:"e051fbf1-e727-5e4c-bfa7-e058e58499c0_VERTICAL"}D{i:31;uuid:"e051fbf1-e727-5e4c-bfa7-e058e58499c0_VERTICAL_SpacerFrontal"}
D{i:32;uuid:"6e968c8c-2da6-591b-bbe2-ff28445e240c"}D{i:33;uuid:"b9a1ae97-a638-5eb0-a037-67ca4a6ed926"}
D{i:34;uuid:"02a198c6-e18d-58b6-8817-2940df406439"}D{i:35;uuid:"3b2b7eaa-d6b3-5d51-84bc-b3449fb1c710"}
D{i:36;uuid:"e051fbf1-e727-5e4c-bfa7-e058e58499c0_VERTICAL_SpacerRear"}D{i:37;uuid:"eafc9656-5c7c-5e79-bed4-4566e8289dee"}
D{i:38;uuid:"7b10ec48-a6e1-540d-9534-edb94432ebe4"}D{i:39;uuid:"5b15a34f-c58c-5eb5-9325-71435157b51e_VERTICAL_SpacerRear"}
}
##^##*/
