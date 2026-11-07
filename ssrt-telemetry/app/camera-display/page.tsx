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

                <table>
                    <tr>
                        <td><Camera cam_id={1} deg={1} zoom={1}/></td>
                        <td><Camera cam_id={2} deg={1} zoom={1}/></td>
                        <td><Camera cam_id={1} deg={1} zoom={1}/></td>
                    </tr>
                    <tr>
                        <td><Camera cam_id={1} deg={45} zoom={1}/></td>
                        <td><Camera cam_id={2} deg={1} zoom={1}/></td>
                        <td><Camera cam_id={1} deg={1} zoom={1}/></td>
                    </tr>
                    <tr>
                        <td><Camera cam_id={1} deg={1} zoom={3}/></td>
                        <td><Camera cam_id={2} deg={1} zoom={1}/></td>
                        <td><Camera cam_id={1} deg={1} zoom={1}/></td>
                    </tr>
                </table>

            </div>
        </div>


    )
}
