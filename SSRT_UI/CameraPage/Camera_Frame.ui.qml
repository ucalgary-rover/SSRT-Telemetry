import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.15
import "../Components"
import "../"
import "../AddtionalUIComponents/"

Rectangle {
    id: cameraFrame
    width: 1920
    height: 1080
    color: "transparent"

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
        RowLayout {
            ColumnLayout {
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
                    Rectangle {
                        id: divider
                        width: 1920
                        height: 2
                        anchors.left: parent.left
                        anchors.top: parent.top
                        color: "#7b664c"
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
                            CameraCheckbox {
                                cameraNum: "Camera 1"
                                anchors.bottom: parent.bottom
                            }
                            CameraCheckbox {
                                cameraNum: "Camera 2"
                                anchors.bottom: parent.bottom
                            }
                            CameraCheckbox {
                                cameraNum: "Camera 3"
                                anchors.bottom: parent.bottom
                            }
                            CameraCheckbox {
                                cameraNum: "Camera 4"
                                anchors.bottom: parent.bottom
                            }
                            CameraCheckbox {
                                cameraNum: "Camera 5"
                                anchors.bottom: parent.bottom
                            }
                            CameraCheckbox {
                                cameraNum: "Camera 6"
                                anchors.bottom: parent.bottom
                            }
                            CameraCheckbox {
                                cameraNum: "Camera 7"
                                anchors.bottom: parent.bottom
                            }
                            CameraCheckbox {
                                cameraNum: "Camera 8"
                                anchors.bottom: parent.bottom
                            }
                        }
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;uuid:"99ee71ff-49a7-54cb-ae01-56b83a22a680"}
}
##^##*/
