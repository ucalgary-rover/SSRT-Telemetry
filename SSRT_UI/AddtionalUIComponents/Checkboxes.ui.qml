import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import QtQuick.Studio.Components 1.0
import QtQuick.Shapes 1.0

Rectangle {
    id: checkboxes
    width: 48
    height: 48
    color: "transparent"
    state: "type_Selected_State_Enabled"

    ColumnLayout {
        id: checkboxes_layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: 0
        Rectangle {
            id: state_layer
            x: 4
            y: 4
            width: 40
            height: 40
            color: "transparent"
            radius: 100
            RowLayout {
                id: state_layer_layout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: 11
                anchors.rightMargin: 11
                anchors.topMargin: 11
                anchors.bottomMargin: 11
                spacing: 0
                Rectangle {
                    id: container
                    x: 11
                    y: 11
                    width: 18
                    height: 18
                    color: "#65558f"
                    radius: 2
                    Layout.preferredWidth: 18
                    Layout.preferredHeight: 18
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
            }

            Check_small {
                id: check_small
                width: 24
                height: 24
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            SvgPathItem {
                id: ripple
                opacity: 0.2
                visible: false
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.leftMargin: -10
                anchors.topMargin: 5
                strokeStyle: 0
                strokeColor: "transparent"
                path: "M 50 3.904856540061332 L 50 31.216212607718802 C 50 33.30594037030194 48.34179348415799 35 46.2962962962963 35 L 0 35 C 0 15.670033532219964 15.338392610903139 0 34.25925925925926 0 C 39.93416892157661 0 45.286810839617694 1.4096326763565479 50 3.904856540061332 Z"
                joinStyle: 0
                fillColor: "#1d1b20"
                antialiasing: true
            }

            Check_indeterminate_small {
                id: check_indeterminate_small
                width: 24
                height: 24
                visible: false
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
    }
    states: [
        State {
            name: "type_Selected_State_Enabled"

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: container
                color: "#65558f"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Selected_State_Disabled"

            PropertyChanges {
                target: checkboxes
                opacity: 0.38
            }

            PropertyChanges {
                target: container
                color: "#1d1b20"
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Indeterminate_State_Hovered"

            PropertyChanges {
                target: state_layer
                color: "#1465558f"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: container
                color: "#65558f"
            }
        },
        State {
            name: "type_Selected_State_Hovered"

            PropertyChanges {
                target: state_layer
                color: "#1465558f"
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: container
                color: "#65558f"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Error_unselected_State_Hovered"

            PropertyChanges {
                target: state_layer
                color: "#14b3261e"
                clip: true
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#b3261e"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Selected_State_Focused"

            PropertyChanges {
                target: state_layer
                color: "#1f65558f"
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: container
                color: "#65558f"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Selected_State_Pressed"

            PropertyChanges {
                target: state_layer
                color: "#1f65558f"
                clip: true
            }

            PropertyChanges {
                target: checkboxes
                radius: 100
            }

            PropertyChanges {
                target: ripple
                visible: true
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: container
                color: "#65558f"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Indeterminate_State_Enabled"

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: container
                color: "#65558f"
            }
        },
        State {
            name: "type_Indeterminate_State_Disabled"

            PropertyChanges {
                target: checkboxes
                opacity: 0.38
            }

            PropertyChanges {
                target: container
                color: "#1d1b20"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }
        },
        State {
            name: "type_Indeterminate_State_Focused"

            PropertyChanges {
                target: state_layer
                color: "#1f65558f"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: container
                color: "#65558f"
            }
        },
        State {
            name: "type_Indeterminate_State_Pressed"

            PropertyChanges {
                target: state_layer
                color: "#1f65558f"
                clip: true
            }

            PropertyChanges {
                target: checkboxes
                radius: 100
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: true
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: container
                color: "#65558f"
            }
        },
        State {
            name: "type_Unselected_State_Enabled"

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#49454f"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Error_selected_State_Enabled"

            PropertyChanges {
                target: container
                color: "#b3261e"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Unselected_State_Disabled"

            PropertyChanges {
                target: checkboxes
                opacity: 0.38
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#1d1b20"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }
        },
        State {
            name: "type_Unselected_State_Hovered"

            PropertyChanges {
                target: state_layer
                color: "#141d1b20"
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#1d1b20"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Unselected_State_Focused"

            PropertyChanges {
                target: state_layer
                color: "#1f1d1b20"
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#1d1b20"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Error_selected_State_Disabled"

            PropertyChanges {
                target: checkboxes
                opacity: 0.38
            }

            PropertyChanges {
                target: container
                color: "#1d1b20"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Unselected_State_Pressed"

            PropertyChanges {
                target: state_layer
                color: "#1f1d1b20"
                clip: true
            }

            PropertyChanges {
                target: checkboxes
                radius: 100
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#1d1b20"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: true
                fillColor: "#65558f"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }
        },
        State {
            name: "type_Error_selected_State_Focused"

            PropertyChanges {
                target: state_layer
                color: "#1fb3261e"
            }

            PropertyChanges {
                target: container
                color: "#b3261e"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Error_selected_State_Hovered"

            PropertyChanges {
                target: state_layer
                color: "#14b3261e"
            }

            PropertyChanges {
                target: container
                color: "#b3261e"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: checkboxes
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Error_indeterminate_State_Disabled"

            PropertyChanges {
                target: checkboxes
                opacity: 0.38
            }

            PropertyChanges {
                target: container
                color: "#1d1b20"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }
        },
        State {
            name: "type_Error_selected_State_Pressed"

            PropertyChanges {
                target: state_layer
                color: "#1fb3261e"
                clip: true
            }

            PropertyChanges {
                target: checkboxes
                radius: 100
            }

            PropertyChanges {
                target: container
                color: "#b3261e"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: true
                fillColor: "#b3261e"
            }

            PropertyChanges {
                target: check_small
                visible: true
            }
        },
        State {
            name: "type_Error_indeterminate_State_Enabled"

            PropertyChanges {
                target: state_layer
                color: "transparent"
                clip: true
            }

            PropertyChanges {
                target: container
                color: "#b3261e"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Error_indeterminate_State_Hovered"

            PropertyChanges {
                target: state_layer
                color: "#14b3261e"
                clip: true
            }

            PropertyChanges {
                target: container
                color: "#b3261e"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Error_indeterminate_State_Focused"

            PropertyChanges {
                target: state_layer
                color: "#1fb3261e"
                clip: true
            }

            PropertyChanges {
                target: container
                color: "#b3261e"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Error_indeterminate_State_Pressed"

            PropertyChanges {
                target: state_layer
                color: "#1fb3261e"
                clip: true
            }

            PropertyChanges {
                target: checkboxes
                radius: 100
            }

            PropertyChanges {
                target: container
                color: "#b3261e"
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: true
            }

            PropertyChanges {
                target: ripple
                visible: true
                fillColor: "#b3261e"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }
        },
        State {
            name: "type_Error_unselected_State_Enabled"

            PropertyChanges {
                target: state_layer
                color: "transparent"
                clip: true
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#b3261e"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Error_unselected_State_Disabled"

            PropertyChanges {
                target: checkboxes
                opacity: 0.38
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#49454f"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: state_layer
                color: "transparent"
            }
        },
        State {
            name: "type_Error_unselected_State_Focused"

            PropertyChanges {
                target: state_layer
                color: "#1fb3261e"
                clip: true
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#b3261e"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: false
                fillColor: "#1d1b20"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }

            PropertyChanges {
                target: checkboxes
            }
        },
        State {
            name: "type_Error_unselected_State_Pressed"

            PropertyChanges {
                target: state_layer
                color: "#1fb3261e"
                clip: true
            }

            PropertyChanges {
                target: checkboxes
                radius: 100
            }

            PropertyChanges {
                target: container
                color: "transparent"
                border.color: "#b3261e"
                border.width: 2
            }

            PropertyChanges {
                target: check_indeterminate_small
                visible: false
            }

            PropertyChanges {
                target: ripple
                visible: true
                fillColor: "#b3261e"
            }

            PropertyChanges {
                target: check_small
                visible: false
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;uuid:"54965424-cb29-5916-8f99-2c9bc04f72b3"}D{i:1;uuid:"54965424-cb29-5916-8f99-2c9bc04f72b3_VERTICAL"}
D{i:2;uuid:"c304efcc-7cc1-5d15-9bbd-216516ef7d63"}D{i:3;uuid:"c304efcc-7cc1-5d15-9bbd-216516ef7d63_HORIZONTAL"}
D{i:4;uuid:"986c13d3-2680-5557-bf38-05519b3aa7d1"}D{i:5;uuid:"8c13a5f5-bf45-5900-8170-4570f6416fb5"}
D{i:6;uuid:"be95fd53-54f1-544c-ace5-acfe2c98c7c2"}D{i:7;uuid:"f26c2ad1-b4f6-5ac5-bb84-dc7bc1e74213"}
}
##^##*/

