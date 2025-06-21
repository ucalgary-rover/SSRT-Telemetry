cmake_minimum_required(VERSION 3.16)

project(SSRTelemetry VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
# Tell CMake where to look for your custom-built Qt modules (including MQTT)
list(INSERT CMAKE_PREFIX_PATH 0 "/home/charbel")
set(Qt6Mqtt_DIR "/home/danijourdain/lib/cmake/Qt6Mqtt")

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Location)
find_package(Qt6 REQUIRED COMPONENTS Positioning)
find_package(Qt6 6.8.1 REQUIRED COMPONENTS Quick Mqtt)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_resources(RESOURCE_SOURCES
    Resources.qrc
)

qt_add_executable(appSSRTelemetry
    main.cpp
    ${RESOURCE_SOURCES}
)

qt_add_qml_module(appSSRTelemetry
    URI SSRTelemetry
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES roverangle.hpp roverangle.cpp
        SOURCES roverTracker.hpp roverTracker.cpp
        SOURCES sciencesensors.hpp sciencesensors.cpp
        SOURCES rovermqtt.hpp rovermqtt.cpp
        SOURCES maplabel.hpp
        SOURCES labelmanager.hpp
        SOURCES labelmanager.cpp
        SOURCES maplabel.cpp
        SOURCES imudata.hpp imudata.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSSRTelemetry PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSSRTelemetry
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSSRTelemetry
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Location
    PRIVATE Qt6::Positioning
    PRIVATE Qt6::Mqtt
)

include(GNUInstallDirs)
install(TARGETS appSSRTelemetry
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
