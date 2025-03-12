cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

project(Pack)

include(ExternalProject)

find_package(ROOT QUIET)
if(ROOT_FOUND)
  message("Using existing ROOT")
  set(root_dep "")
  set(root_cmake $ENV{CMAKE_PREFIX_PATH})
else()
  message("Download and build ROOT from https://root.cern/download/root_v6.34.02.source.tar.gz")
  ExternalProject_Add(
     ROOT
     URL https://root.cern/download/root_v6.34.02.source.tar.gz
     URL_HASH SHA256=166bec562e420e177aaf3133fa3fb09f82ecddabe8a2e1906345bad442513f94
     DOWNLOAD_EXTRACT_TIMESTAMP false
     BINARY_DIR root
     CMAKE_ARGS -Dwebgui=ON -Dqt6web=ON -Dxrootd=OFF -Dbuiltin_xrootd=OFF -Ddavix=OFF -Dbuiltin_vdt=OFF -Dvdt=OFF -Dbuiltin_glew=ON
     INSTALL_COMMAND ""
  )
  set(root_dep ROOT)
  set(root_cmake ${CMAKE_BINARY_DIR}/root)
endif()

ExternalProject_Add(
   GO4
   SOURCE_DIR ${CMAKE_SOURCE_DIR}/go4
   BINARY_DIR go4
   DEPENDS ${root_dep}
   CMAKE_ARGS -Dexamples=OFF -Dqt6=ON -DCMAKE_PREFIX_PATH=${root_cmake}
   INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/go4/go4login ${CMAKE_BINARY_DIR}
)

ExternalProject_Add(
   STREAM
   SOURCE_DIR ${CMAKE_SOURCE_DIR}/stream
   BINARY_DIR stream
   DEPENDS GO4 ${root_dep}
   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${root_cmake}$<SEMICOLON>${CMAKE_BINARY_DIR}/go4
   INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/stream/streamlogin ${CMAKE_BINARY_DIR}
)

ExternalProject_Add(
   DABC
   SOURCE_DIR ${CMAKE_SOURCE_DIR}/dabc
   BINARY_DIR dabc
   DEPENDS ${root_dep} GO4 STREAM
   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${root_cmake}$<SEMICOLON>${CMAKE_BINARY_DIR}/go4$<SEMICOLON>${CMAKE_BINARY_DIR}/stream
   INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/dabc/dabclogin ${CMAKE_BINARY_DIR}
)

configure_file(${CMAKE_SOURCE_DIR}/scripts/dabcgo4login.in
              ${CMAKE_BINARY_DIR}/dabcgo4login @ONLY NEWLINE_STYLE UNIX)
