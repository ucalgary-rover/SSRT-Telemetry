import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts 1.15
import "../Components"

StackLayout {
    anchors.fill: parent
    width: parent.width
    currentIndex: tabBar.currentIndex
    Page {
        header: Application_Layout {
            id: application_Layout
            width: 1920
            height: 150
            anchors.left: parent.left
            anchors.top: parent.top
        }

        Homepage {
            color: "#f3d5b5"
        }

    Item {
        id:telemetrytabbutton
    }

    Item {
        id:camerabutton
    }


    }
}
