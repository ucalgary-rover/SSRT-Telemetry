import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import "../Components"
import "../"
import "../AddtionalUIComponents/"

Rectangle {
    id: camera_Frame
    width: 1920
    height: 1080
    color: "transparent"
    property alias camera_6Text: camera_6.text
    property alias camera_7Text: camera_7.text
    property alias camera_2Text: camera_2.text
    property alias camera_5Text: camera_5.text
    property alias camera_3Text: camera_3.text
    property alias camera_4Text: camera_4.text
    property alias camera_8Text: camera_8.text
    property alias camera_1Text: camera_1.text

    Application_Layout {
        id: application_Layout
        width: 1920
        height: 1080
        anchors.left: parent.left
        anchors.top: parent.top
        state: "property_1_Camera"
    }

    Rectangle {
        id: camera_Page
        width: 1920
        height: 933
        color: "transparent"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 147
        Rectangle {
            id: camera_Feeds
            width: 1885
            height: 842
            color: "transparent"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 17
            Camera_View_Layout {
                id: camera_View_Layout
                width: 460
                height: 415
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 475
                anchors.topMargin: 2
            }

            Camera_View_Layout {
                id: camera_View_Layout1
                width: 460
                height: 415
                anchors.left: parent.left
                anchors.top: parent.top
            }

            Camera_View_Layout {
                id: camera_View_Layout2
                width: 460
                height: 415
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 1425
                anchors.topMargin: 428
            }

            Camera_View_Layout {
                id: camera_View_Layout3
                width: 460
                height: 415
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 950
                anchors.topMargin: 427
            }

            Camera_View_Layout {
                id: camera_View_Layout4
                width: 460
                height: 415
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 475
                anchors.topMargin: 428
            }

            Camera_View_Layout {
                id: camera_View_Layout5
                width: 460
                height: 415
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.topMargin: 427
            }

            Camera_View_Layout {
                id: camera_View_Layout6
                width: 460
                height: 415
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 1425
                anchors.topMargin: 2
            }

            Camera_View_Layout {
                id: camera_View_Layout7
                width: 460
                height: 415
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 950
                anchors.topMargin: 2
            }
        }

        Rectangle {
            id: camera_Check_Box_Bar
            width: 1920
            height: 79
            color: "transparent"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 853
            Horizontal_Middle_inset {
                id: horizontal_Middle_inset
                width: 1920
                height: 2
                anchors.left: parent.left
                anchors.top: parent.top
            }

            Rectangle {
                id: camera_Check_Box_Bar1
                width: 1193
                height: 70
                color: "transparent"
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.leftMargin: 381
                anchors.topMargin: 5
                RowLayout {
                    id: camera_Check_Box_Bar_layout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    spacing: 45
                    Rectangle {
                        id: check_Box_with_Label_1
                        x: 0
                        y: 0
                        width: 107
                        height: 70
                        color: "transparent"
                        Text {
                            id: camera_1
                            width: 108
                            height: 29
                            color: "#000000"
                            text: qsTr("Camera 1")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 41
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrapMode: Text.NoWrap
                            font.weight: Font.Normal
                            font.family: "Inter"
                        }

                        Checkboxes {
                            id: checkboxes
                            width: 48
                            height: 48
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 31
                            state: "type_Selected_State_Enabled"
                        }
                        Layout.preferredWidth: 107
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Rectangle {
                        id: check_Box_with_Label_2
                        x: 152
                        y: 0
                        width: 110
                        height: 70
                        color: "transparent"
                        Text {
                            id: camera_2
                            width: 111
                            height: 29
                            color: "#000000"
                            text: qsTr("Camera 2")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 41
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrapMode: Text.NoWrap
                            font.weight: Font.Normal
                            font.family: "Inter"
                        }

                        Checkboxes {
                            id: checkboxes1
                            width: 48
                            height: 48
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 31
                            state: "type_Selected_State_Enabled"
                        }
                        Layout.preferredWidth: 110
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Rectangle {
                        id: checkbox_with_Label_3
                        x: 307
                        y: 0
                        width: 111
                        height: 70
                        color: "transparent"
                        Text {
                            id: camera_3
                            width: 112
                            height: 29
                            color: "#000000"
                            text: qsTr("Camera 3")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 41
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrapMode: Text.NoWrap
                            font.weight: Font.Normal
                            font.family: "Inter"
                        }

                        Checkboxes {
                            id: checkboxes2
                            width: 48
                            height: 48
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 31
                            state: "type_Selected_State_Enabled"
                        }
                        Layout.preferredWidth: 111
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Rectangle {
                        id: checkbox_with_Label_4
                        x: 463
                        y: 0
                        width: 111
                        height: 70
                        color: "transparent"
                        Text {
                            id: camera_4
                            width: 112
                            height: 29
                            color: "#000000"
                            text: qsTr("Camera 4")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 41
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrapMode: Text.NoWrap
                            font.weight: Font.Normal
                            font.family: "Inter"
                        }

                        Checkboxes {
                            id: checkboxes3
                            width: 48
                            height: 48
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 31
                            state: "type_Selected_State_Enabled"
                        }
                        Layout.preferredWidth: 111
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Rectangle {
                        id: checkbox_with_Label_5
                        x: 619
                        y: 0
                        width: 110
                        height: 70
                        color: "transparent"
                        Text {
                            id: camera_5
                            width: 111
                            height: 29
                            color: "#000000"
                            text: qsTr("Camera 5")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 41
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrapMode: Text.NoWrap
                            font.weight: Font.Normal
                            font.family: "Inter"
                        }

                        Checkboxes {
                            id: checkboxes4
                            width: 48
                            height: 48
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 31
                            state: "type_Selected_State_Enabled"
                        }
                        Layout.preferredWidth: 110
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Rectangle {
                        id: checkbox_with_Label_6
                        x: 774
                        y: 0
                        width: 110
                        height: 70
                        color: "transparent"
                        Text {
                            id: camera_6
                            width: 111
                            height: 29
                            color: "#000000"
                            text: qsTr("Camera 6")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 41
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrapMode: Text.NoWrap
                            font.weight: Font.Normal
                            font.family: "Inter"
                        }

                        Checkboxes {
                            id: checkboxes5
                            width: 48
                            height: 48
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 31
                            state: "type_Selected_State_Enabled"
                        }
                        Layout.preferredWidth: 110
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Rectangle {
                        id: checkbox_with_Label_7
                        x: 929
                        y: 0
                        width: 109
                        height: 70
                        color: "transparent"
                        Text {
                            id: camera_7
                            width: 110
                            height: 29
                            color: "#000000"
                            text: qsTr("Camera 7")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 41
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrapMode: Text.NoWrap
                            font.weight: Font.Normal
                            font.family: "Inter"
                        }

                        Checkboxes {
                            id: checkboxes6
                            width: 48
                            height: 48
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 31
                            state: "type_Selected_State_Enabled"
                        }
                        Layout.preferredWidth: 109
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }

                    Rectangle {
                        id: checkbox_with_Label_8
                        x: 1083
                        y: 0
                        width: 110
                        height: 70
                        color: "transparent"
                        Text {
                            id: camera_8
                            width: 111
                            height: 29
                            color: "#000000"
                            text: qsTr("Camera 8")
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.topMargin: 41
                            font.pixelSize: 24
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignTop
                            wrapMode: Text.NoWrap
                            font.weight: Font.Normal
                            font.family: "Inter"
                        }

                        Checkboxes {
                            id: checkboxes7
                            width: 48
                            height: 48
                            anchors.left: parent.left
                            anchors.top: parent.top
                            anchors.leftMargin: 31
                            state: "type_Selected_State_Enabled"
                        }
                        Layout.preferredWidth: 110
                        Layout.preferredHeight: 70
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;uuid:"99ee71ff-49a7-54cb-ae01-56b83a22a680"}D{i:1;uuid:"8aebb83d-15ef-52da-8b44-de3cd6f1af8c"}
D{i:2;uuid:"59ebfb6b-d3a9-5afd-9750-208e7faa76cd"}D{i:3;uuid:"179b6f2f-12ed-5d5b-9dff-29298da69f77"}
D{i:4;uuid:"7e148970-8fff-568f-8751-03a9ec920d4c"}D{i:5;uuid:"dc854082-4f7f-5c36-8d1d-d51647b11ad8"}
D{i:6;uuid:"a4a9f843-4eea-55d7-8a34-fba852d13eee"}D{i:7;uuid:"8b2beb9e-0e4e-548c-b33d-f191bb45550d"}
D{i:8;uuid:"f5d47690-dc85-56a5-bca0-a61751d5da1d"}D{i:9;uuid:"d7aa204c-138c-59f2-9f53-4f36f031d3a8"}
D{i:10;uuid:"97a5a6c5-ec5a-518e-be60-086ddd603985"}D{i:11;uuid:"f53fd763-963e-5c0d-aed1-eee65c1e7cf2"}
D{i:12;uuid:"83476766-f964-5bb4-adea-adcc0f766b42"}D{i:13;uuid:"29538e7a-795e-5f81-ba74-eded31abe31b"}
D{i:14;uuid:"009f2014-61a0-5366-b02b-5dc3dd4e0960"}D{i:15;uuid:"009f2014-61a0-5366-b02b-5dc3dd4e0960_HORIZONTAL"}
D{i:16;uuid:"a76e5fca-2a69-580b-9f1b-dcb4b394c745"}D{i:17;uuid:"18c10449-f8e3-541c-b330-2466d7b9a7a6"}
D{i:18;uuid:"a5eb839c-d777-5401-9de2-779a2e5ac258"}D{i:19;uuid:"328add1d-a76f-5fe0-9c93-2a80a3fb9d70"}
D{i:20;uuid:"c8366b7d-38dc-5ac3-930e-97586611d2dd"}D{i:21;uuid:"43829ff7-73ee-5310-af94-b03681e76e1a"}
D{i:22;uuid:"b359aeba-1711-5ba7-94ea-b85b9e1b9935"}D{i:23;uuid:"ec2e54c9-b752-5016-9822-5eae32150bf0"}
D{i:24;uuid:"7a4c46c5-3eeb-5c63-aaf0-963383001222"}D{i:25;uuid:"aa6a69c1-9f86-5a9d-aa71-974041ed4372"}
D{i:26;uuid:"e7bcbfdd-cc8a-5dc0-a6c1-b91ba9ab97ab"}D{i:27;uuid:"0b339491-fc76-5ee5-9b43-aeadbb7d91bb"}
D{i:28;uuid:"fe8ccbd0-e169-504a-8853-0f9d48180ef9"}D{i:29;uuid:"f38009f7-c09f-5489-9181-34813184f556"}
D{i:30;uuid:"09723eea-5b83-5fd3-a243-452d286228fc"}D{i:31;uuid:"76a0d0c8-124d-51c7-9960-81b551ee2c1c"}
D{i:32;uuid:"01a51c5e-61e1-5a92-83ee-b1c5656bf4ae"}D{i:33;uuid:"3f94f946-8910-57b8-89f6-622933147682"}
D{i:34;uuid:"93b645df-bdb9-552b-a03c-46435d618c40"}D{i:35;uuid:"2029aaef-3e9e-51f0-945b-8f85dca47da8"}
D{i:36;uuid:"adfc8cf6-fbe9-5d44-8c65-7857c85c5c06"}D{i:37;uuid:"58fb7200-9e96-59a9-8dae-1bd8b0819024"}
D{i:38;uuid:"0fd3fc09-a6dc-5a59-a8a2-c90e3cd87c6f"}D{i:39;uuid:"01898e11-9dfd-550a-a90a-fff92e789215"}
}
##^##*/

