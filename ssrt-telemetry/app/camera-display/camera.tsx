import React from "react";
const ROVER_IP = process.env.ROVER_IP;
const ROVER_CAMERA_PORT = process.env.CAMERA_FEED_PORT;
const VIDEO_URL = `http://${ROVER_IP}:${ROVER_CAMERA_PORT}/video_feed/`

const divStyle: React.CSSProperties = {
    width: "100%",
    maxWidth: "900px", // camelCase and value wrapped in quotes
    overflow: "hidden", // wrapped in quotes
    position: "relative" // wrapped in quotes
};

interface CameraProps {
    cam_id:number;
    deg:number;
    zoom:number;
}


export default function Camera({cam_id, deg, zoom}): CameraProps {


    const cameraStyle: React.CSSProperties = {
        width: "100%",
        height: "100%",
        objectFit: "cover",
        transform: `rotate(${deg}deg) scale(${zoom})`,
        transformOrigin: "center center"
    }

    const cameraURL = `${VIDEO_URL}${cam_id}`;

    return (
        <div id="cam_{cam_id}" style={divStyle}>
        <img src={cameraURL} style={cameraStyle} />
        </div>
    )
}
