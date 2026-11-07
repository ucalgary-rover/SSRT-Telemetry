# run to test cameras using local device
# pip install flask opencv-contrib-python
import cv2
from flask import Flask
from flask import Response

app = Flask(__name__)


def generate_frames(cam_id):
    # Explicitly use DirectShow or Media Foundation on Windows for multi-camera support
    camera = cv2.VideoCapture(cam_id, cv2.CAP_MSMF)

    try:
        while True:
            success, frame = camera.read()
            if not success:
                break
            _, buffer = cv2.imencode(".jpg", frame)
            yield (
                b"--frame\r\n"
                b"Content-Type: image/jpeg\r\n\r\n" + buffer.tobytes() + b"\r\n"
            )
    finally:
        camera.release()


@app.route("/video_feed/<int:cam_id>")
def video_feed(cam_id):
    return Response(
        generate_frames(cam_id), mimetype="multipart/x-mixed-replace; boundary=frame"
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
