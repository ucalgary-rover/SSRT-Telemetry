# SSRTelemetry
Qt application built for sensor visual interface with processing capabilities.

## First install essential build tools for Qt Development

### On Ubuntu
Install make and other build tools like gcc ```sudo apt install build-essential```.
Install CMake ```sudo apt install cmake```.

## Building and Running on Qt Creator
The base application can be run in Qt Creator GUI simply by opening the CMakelists.txt file witin the project folder. Qt Creator may or may not need to be configured to detect build tool executables. For some systems it may auto detect the bin executables (make, cmake etc.) for you.

## Building and running manually with CMake
Will require a version of CMake (A cross platform build system that creates makefiles), make (Compiles and builds C/C++ files) and GNU Build tools.

The typical way to build manually is by first creating a directory in the project folder itself. Run ```mkdir build```.

Change directory to the build ```cd build```.

Run CMake ```cmake ..```. This will create the build in the build folder and use the CMakeLists.txt found in the parent directory.

Then run ```make``` to compile.

The application can be ran with ```./appSSRTelemetry```
 
