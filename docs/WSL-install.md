# Setting up Ubuntu on Windows on Ubuntu Environment

WSL setup for building and testing Streamlit on Windows with Linux WSL.

## Prerequisities

Windows 10 Build 19044+ or Windows 11

## WSL Installation

On Powershell run:
```wsl --install --distribution Ubuntu-22.04```

On Windows, this distribution is now accessible as an application.

## Using a custom kernel

Download the `bzImage` and `modules.vhdx` files from the [Google Drive](https://drive.google.com/drive/folders/1jZEXCGR5h4lNIo2Oa7Yx92Sdc44gI8pG?usp=drive_link)

Move them into an easily accessible location in your C: drive such as `C:\\WSL\\kernel`

Create `.wslconfig` in `C:\\%USERPROFILE%\\` if it doesn't already exist. Add the following contents to the file:

```
[wsl2]
kernel=path\\to\\bzImage
kernelModules=path\\to\\modules.vhdx
```

Open a PowerShell terminal window as an Administator

Stop WSL using `wsl --shutdown`

Wait 10 seconds then restart WSL

## Install `usbipd`

Install `usbipd` from [this](https://github.com/dorssel/usbipd-win/releases) link.

List all USB devices with `usbipd list`

In an **administrator** command prompt, attach the device using `usbipd bind --busid 4-4`, replacing the bus ID with the one matching your desired device

Attach the device to WSL using `usbipd attach --wsl --busid 4-4`

In WSL, you should now see the device when you run `lsusb`.

Instructions are also available [here](https://learn.microsoft.com/en-us/windows/wsl/connect-usb)

## Installing Python with WSL

Update distribution:
```sudo apt-get update```

Install Git:
```sudo apt-get install git```

Install Python:
```sudo apt install python3 python3-pip```
