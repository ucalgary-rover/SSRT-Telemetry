#To run this program you will need Next React, Leaflet and uvicorn

How to install next React:
```Bash
npm i next@latest react@latest react-dom@latest
```
How to install leaflet
```Bash
npm install react@rc react-dom@rc leaflet
```

How to install uvicorn:
```Bash
pip install uvicorn
```

#If you are working on the map or want to use the map you will need to download the tiles zip file from the drive, and place them in ssrt-telemetry/public



how to run program:
	in one terminal run 
		```bash
    python -m uvicorn api:app --reload 
    ```
	which connects you to the backend, then in the other
    ```
		npm.cmd run dev
    ```
