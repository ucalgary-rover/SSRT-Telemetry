import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15
import SSRTelemetry;

Item {
    id: compass
    width: 200
    height: 250

    IMUData {
        id: imuDataController
    }

    // Public properties to bind to
    property real heading: 0        // Degrees, 0–360
    property string direction: "N"  // Cardinal direction

    // Background Compass Circle
    Canvas {
        id: compassBackground
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 200
        height: 200
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            ctx.save();
            ctx.translate(width/2, height/2);

            // Draw outer circle
            ctx.beginPath();
            ctx.arc(0, 0, 90, 0, 2 * Math.PI);
            ctx.fillStyle = Qt.rgba(243, 213, 181, 0.7);
            ctx.fill()
            ctx.strokeStyle = "#888";
            ctx.lineWidth = 3;
            ctx.stroke();

            // Draw N-E-S-W labels
            const labels = ["N", "E", "S", "W"];
            for (var i = 0; i < 4; ++i) {
                const angle = i * Math.PI / 2;
                const x = Math.sin(angle) * 70;
                const y = -Math.cos(angle) * 70;
                ctx.font = "16px sans-serif";
                ctx.fillStyle = "#000";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.fillText(labels[i], x, y);
            }

            ctx.restore();
        }
    }

    // Rotating Arrow
    Rectangle {
        id: needle
        width: 6
        height: 80
        color: "red"
        radius: 3
        anchors.horizontalCenter: compassBackground.horizontalCenter
        anchors.bottom: compassBackground.verticalCenter
        transform: Rotation {
            origin.x: needle.width / 2
            origin.y: needle.height
            angle: imuDataController.heading_angle
        }
    }

    // Text labels
    Column {
        spacing: 4
        anchors.top: compassBackground.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: imuDataController.heading_angle.toFixed(1) + "°"
            font.pointSize: 16
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: imuDataController.heading_cardinal
            font.pointSize: 14
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
