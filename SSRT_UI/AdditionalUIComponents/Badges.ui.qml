import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15

Rectangle {
    id: badges
    width: 16
    height: 16
    color: "#b3261e"
    radius: 100
    property alias badge_labelText: badge_label.text
    state: "size_Large"
    clip: true

    RowLayout {
        id: badges_layout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        spacing: 0
        Text {
            id: badge_label
            x: 4
            y: 0
            width: 10
            height: 16
            color: "#ffffff"
            text: qsTr("3")
            font.pixelSize: 11
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            lineHeight: 16
            lineHeightMode: Text.FixedHeight
            wrapMode: Text.Wrap
            font.weight: Font.Medium
            font.family: "Roboto"
            Layout.preferredHeight: 16
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        Rectangle {
            id: spacer
            x: 2
            y: 2
            width: 2
            height: 2
            visible: false
            color: "transparent"
            clip: true
            Layout.preferredWidth: 2
            Layout.preferredHeight: 2
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
    }
    states: [
        State {
            name: "size_Small"

            PropertyChanges {
                target: badges
                width: 6
                height: 6
                clip: false
            }

            PropertyChanges {
                target: spacer
                visible: true
            }

            PropertyChanges {
                target: badge_label
                visible: false
            }

            PropertyChanges {
                target: badges_layout
                anchors.leftMargin: 2
                anchors.rightMargin: 2
                anchors.topMargin: 2
                anchors.bottomMargin: 2
            }
        },
        State {
            name: "size_Large"

            PropertyChanges {
                target: badges
                width: 16
                height: 16
                clip: true
            }

            PropertyChanges {
                target: spacer
                visible: false
            }

            PropertyChanges {
                target: badge_label
                visible: true
            }

            PropertyChanges {
                target: badges_layout
                anchors.leftMargin: 4
                anchors.rightMargin: 4
            }
        }
    ]
}

/*##^##
Designer {
    D{i:0;uuid:"e45d1921-08fa-5557-942e-f24b5427cfae"}D{i:1;uuid:"e45d1921-08fa-5557-942e-f24b5427cfae_HORIZONTAL"}
D{i:2;uuid:"ecf9ec21-658d-5f0a-b948-64f3fa44e62b"}D{i:3;uuid:"04abee3d-1046-5809-b10b-8f3f3250ff2a"}
}
##^##*/
