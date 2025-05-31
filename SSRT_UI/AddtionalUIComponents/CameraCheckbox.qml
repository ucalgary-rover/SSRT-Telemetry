import QtQuick
import QtQuick.Controls

CheckBox {
    id: control
    text: qsTr("CheckBox")
    state: "unchecked"
    font.pointSize: 20
    checked: true
    property string cameraNum

    indicator: indicatorRectangle
    Rectangle {
        id: indicatorRectangle
        implicitWidth: 26
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        color: "#8f4c34"
        radius: 3
        border.color: "#7b664c"
        Rectangle {
            id: rectangle
            width: 14
            height: 14
            x: 6
            y: 6
            radius: 2
            border.color: "#7b664c"
            visible: false
            color: "#8f4c34"
        }
    }

    contentItem: Text {
        id: textItem
        width: implicitWidth
        height: implicitHeight
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "#000000"
        text: control.cameraNum
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
    states: [
        State {
            name: "checked"
            when: control.checked

            PropertyChanges {
                target: rectangle
                visible: true
                color: "#8f4c34"
            }

            PropertyChanges {
                target: indicatorRectangle
                color: "#00000000"
                border.color: "#7b664c"
            }

            PropertyChanges {
                target: textItem
                color: "#000000"
            }
        },
        State {
            name: "unchecked"
            when: !control.checked

            PropertyChanges {
                target: rectangle
                visible: false
            }

            PropertyChanges {
                target: indicatorRectangle
                color: "#00000000"
                border.color: "#7b664c"
            }

            PropertyChanges {
                target: textItem
                color: "#000000"
            }
        }
    ]
}
