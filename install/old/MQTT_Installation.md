# Qt MQTT – Building & Installing from Source for Qt 6.8.1

This README explains how to clone and build the Qt MQTT module from source for Qt 6.8.1 on a Linux system. Adapt paths and commands as needed for your environment.

## Prerequisites

- **Qt 6.8.1** (this example uses `/home/charbel/Qt/6.8.1/gcc_64`)
- **CMake**
- **C++ Toolchain** (e.g., GCC)

## 1. Clone the Qt MQTT Repository

```bash
git clone -b 6.8.1 https://code.qt.io/qt/qtmqtt.git
cd qtmqtt
```

**Note:** The exact branch or tag might differ (e.g., `6.8`, `v6.8.1`) based on how the Qt repository is set up. Verify the available branches/tags before cloning.

## 2. Create a Build Directory

We'll build out-of-source:

```bash
mkdir build
cd build
```

## 3. Configure the Build

Specify:
* `CMAKE_INSTALL_PREFIX` to choose where Qt MQTT will be installed.
* `CMAKE_PREFIX_PATH` so CMake can locate your Qt 6.8.1 installation.
* `CMAKE_BUILD_TYPE=Release` for an optimized build .

Example:

```bash
cmake \
  -DCMAKE_INSTALL_PREFIX=/home/charbel \
  -DCMAKE_PREFIX_PATH=/home/charbel/Qt/6.8.1/gcc_64 \
  -DCMAKE_BUILD_TYPE=Release \
  ..
```

## 4. Build and Install

1. **Build** the project:

```bash
cmake --build .
```

2. **Install** it into the prefix specified above:

```bash
cmake --install .
```

## 5. Verify the Installation

1. **Check the Install Folder**
Look under `/home/charbel` (or the folder you used in `CMAKE_INSTALL_PREFIX`) for the newly installed Qt MQTT files. You should see something like:

```
/home/charbel/
└── lib/
    ├── cmake/Qt6Mqtt
    ├── libQt6Mqtt.so
    └── ...
```

2. **Test in a New Qt Project**
In a CMake-based Qt project, add the following to your `CMakeLists.txt` which I already have done just make sure its there:

```cmake
find_package(Qt6 COMPONENTS Mqtt REQUIRED)
target_link_libraries(MyApp PRIVATE Qt6::Mqtt)
```

Rebuild your project. If it configures and links without error, Qt MQTT has been installed successfully.

That should be all! Hopefully there are no problems
