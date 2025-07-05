#  QtMqtt Manual Build Instructions
Details manual build process of QtMqtt module, the bash files provided automate this.

## Building through bash files

### Make executables
Choose version of QtMqtt to build and use chmod

```bash
chmod +x build_qtmqtt_[version]_.sh
```

### Execute bash file

```bash
./build_qtmqtt_[version]
```

## Building manually

### 1. Clone source QtMqtt Repository 

```bash
git clone -b 6.8.1 https://code.qt.io/qt/qtmqtt.git
cd qtmqtt
```

Note: The exact branch or tag might differ (e.g., 6.8, v6.8.1) based on how the Qt repository is set up. Verify the available
branches/tags before cloning. 
### 2. Create a Build Directory 
We’ll build out-of-source: 

```bash
mkdir build
cd build
```

### 3. Configure the Build 
Specify: * CMAKE_INSTALL_PREFIX to choose where Qt MQTT will be installed. * CMAKE_PREFIX_PATH so CMake can locate your
Qt installation. * CMAKE_BUILD_TYPE=Release for an optimized build. 
Example:

```bash 
cmake \
-DCMAKE_INSTALL_PREFIX=/[my-home-directory]/Qt/6.8.1/gcc_64 \
-DCMAKE_PREFIX_PATH=/[my-home-directory]/Qt/6.8.1/gcc_64 \ 
-DCMAKE_BUILD_TYPE=Release \
..
```

Note: _INSTALL_PREFIX and PREFIX_PATH have to be the same to both fetch the Qt source needed to build QtMqtt and install QtMqtt into source folders
containing other modules.

### 4. Build and Install 
Build the project:

```bash 
cmake --build .
```

Install it into the prefix specified above: 

```bash
cmake --install .
```

### 5. Verify the Installation 
Check the Install Folder by looking under: 
[my-home-directory]/Qt/6.8.1/gcc_64/lib/

├── cmake/Qt6Mqtt

├── libQt6Mqtt.so

└── ...
Test in a New Qt Project In a CMake-based Qt project, add the following to your CMakeLists.txt
find_package(Qt6 COMPONENTS Mqtt REQUIRED)
target_link_libraries(MyApp PRIVATE Qt6::Mqtt)

