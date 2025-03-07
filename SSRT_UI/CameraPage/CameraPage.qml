import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

StackLayout {
    anchors.fill: parent
    currentIndex: 0   // set to 0 since we have one child

    // Wrap the Text inside an Item to make it a proper child
    Item {
        anchors.fill: parent

        Text {
            text: "Hello, World!"
            font.pixelSize: 32
            color: "black"
            anchors.centerIn: parent
        }
    }
}
