import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts 1.15
import "../Components"

StackLayout {
    anchors.fill: parent
    width: parent.width
    currentIndex: tabBar.currentIndex

    Homepage {
        color: "#f3d5b5"
    }

}
