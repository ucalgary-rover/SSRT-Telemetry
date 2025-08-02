#!/usr/bin/env bash
set -eo pipefail

############################################
# Configure this path for your setup
QT_DIR="$HOME/Qt/6.8.1/gcc_64"
BRANCH="6.8.1"
############################################

echo "Cloning Qt MQTT module (branch: $BRANCH)…"
if [[ -d qtmqtt ]]; then
  git -C qtmqtt pull
else
  git clone -b "$BRANCH" https://code.qt.io/qt/qtmqtt.git
fi
cd qtmqtt

echo "Building in out-of-source 'build' directory…"
rm -rf build
mkdir build && cd build

echo "Configuring with CMake…"
cmake \
  -DCMAKE_INSTALL_PREFIX="$QT_DIR" \
  -DCMAKE_PREFIX_PATH="$QT_DIR" \
  -DCMAKE_BUILD_TYPE=Release \
  ..

echo "Compiling…"
cmake --build . --parallel

echo "Installing to $QT_DIR…"
cmake --install .

echo ""
echo "✅ Qt MQTT built and installed to '$QT_DIR'"
echo "Check the module here:"
echo "  ls \"$QT_DIR/lib/cmake/Qt6Mqtt\""
echo ""
echo "To use in your project’s CMakeLists.txt:"
echo "  list(INSERT CMAKE_PREFIX_PATH 0 \"$QT_DIR\")"
echo "  find_package(Qt6 REQUIRED COMPONENTS Mqtt)"
echo "  target_link_libraries(<your-target> PRIVATE Qt6::Mqtt)"
