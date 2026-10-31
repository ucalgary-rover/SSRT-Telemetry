import Camera from './camera'

export default function Page() {
    return (
        <div>
            <head>
                <title>Evil Camera Page</title>
            </head>
            <div>
                <h1>
                Hello, Camera Page!
                </h1>
                <p>
                    Evil Camera Page
                </p>
                <Camera cam_id={1} deg={1} zoom={1}/>
            </div>
        </div>
        
        
    )
}