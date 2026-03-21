# SSRTelemetry

Streamlit application built for sensor visual interface with processing capabilities.

## Running the app
```bash
streamlit run app.py
```

Then follow the URL to open the app in your browser.

## Running the local map tile server

### First time running

1. Go to [https://www.maptiler.com/data/](https://www.maptiler.com/data/) and create an account.

2. Sign in to your account

3. Go to [Downloads](https://data.maptiler.com/my-extracts/) on the side bar

4. Click the `New Dataset` button and download a dataset for Alberta

5. Select the OpenStreetMap option and Continue

6. Select **Non-commercial personal project** and agree to all conditions on the free plan

7. Transfer the download from Windows to WSL using
```bash
mv /mnt/c/Users/<username>/Downloads/osm-2020-02-10-v3.11_canada_alberta.mbtiles ~/your/desired/wsl/path/SSRT_Alberta_tiles.mbtiles
```

8. Download MapTiler Server for Linux

    a. Go to the [download page](https://data.maptiler.com/server/)

    b. Select Linux and Debian package

    c. Copy the downloaded file to WSL the same way as Step 7.

    d. Install the program using
    ```bash
    sudo dpkg -i maptiler-server-4.7.1-linux-x64.deb
    ```

    e. Ensure it installed correctly using
    ```bash
    maptiler-server --help
    ```

### Running every time

1. Navigate to just outside of where you stored the `.mbtiles` file

2. Start the server using the command below
    - `--workDir`    tells `maptiler-server` where to find the file
    - `--adminPassword` sets the password to log in to the admin console at [http://localhost:3650/admin](http://localhost:3650/admin)
```bash
maptiler-server --workDir <mbtiles-dir>/ --adminPassword ucalgary-rover
```

3. Refresh the Streamlit app and you should have a map!
