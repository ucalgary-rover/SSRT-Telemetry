# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appSSRTelemetry_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appSSRTelemetry_autogen.dir/ParseCache.txt"
  "appSSRTelemetry_autogen"
  )
endif()
