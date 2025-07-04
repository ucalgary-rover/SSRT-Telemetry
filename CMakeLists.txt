cmake_minimum_required(VERSION 3.16)

project(SSRTelemetry VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(Qt6 6.8.1 REQUIRED COMPONENTS Location Positioning Quick Mqtt Core) 
set(CMAKE_AUTOMOC ON)
qt_standard_project_setup(REQUIRES 6.8)

qt_add_resources(RESOURCE_SOURCES
    Resources.qrc
)

qt_add_executable(SSRTTelemetry
    main.cpp
    ${RESOURCE_SOURCES}
)

qt_add_qml_module(SSRTTelemetry
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
        SOURCES rovergpsd.h rovergpsd.cpp
        SOURCES LocationInfo.hpp
        SOURCES imudata.hpp imudata.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(SSRTTelemetry PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.SSRTTelemetry
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)


target_link_libraries(SSRTTelemetry
    PRIVATE Qt6::Quick Qt6::Location Qt6::Positioning Qt6::Mqtt Qt6::Core)

include(GNUInstallDirs)
install(TARGETS SSRTTelemetry
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# Install the application icon (from source assets)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/SSRT_UI/assets/sSRT_Logo.png
        DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/256x256/apps
        RENAME ssrttelemetry.png)
