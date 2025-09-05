cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

project(Pack)

include(ExternalProject)

find_package(ROOT QUIET)
if(ROOT_FOUND)
  message("Using existing ROOT")
  set(root_dep "")
  set(root_cmake $ENV{CMAKE_PREFIX_PATH})
  set(__root_init__ "")
else()
  message("Download and build ROOT from https://root.cern/download/root_v6.36.04.source.tar.gz")
  ExternalProject_Add(
     ROOT
     URL https://root.cern/download/root_v6.36.04.source.tar.gz
     URL_HASH SHA256=cc6367d8f563c6d49ca34c09d0b53cb0f41a528db6f86af111fd76744cda4596
     DOWNLOAD_EXTRACT_TIMESTAMP false
     BINARY_DIR root
     BUILD_ALWAYS 1
     CMAKE_ARGS -Dwebgui=ON -Dqt6web=ON -Dxrootd=OFF -Dbuiltin_xrootd=OFF -Ddavix=OFF -Dbuiltin_vdt=OFF -Dvdt=OFF -Dimt=OFF -Dbuiltin_tbb=OFF -Dbuiltin_glew=ON
     INSTALL_COMMAND ""
  )
  set(root_dep ROOT)
  set(root_cmake ${CMAKE_BINARY_DIR}/root)
  set(__root_init__ "if [[ -z $ROOTSYS ]]; then . ${CMAKE_BINARY_DIR}/root/bin/thisroot.sh; fi")
endif()

ExternalProject_Add(
   GO4
   SOURCE_DIR ${CMAKE_SOURCE_DIR}/go4
   BINARY_DIR go4
   BUILD_ALWAYS 1
   DEPENDS ${root_dep}
   CMAKE_ARGS -Dexamples=OFF -Dqt6=ON -DCMAKE_PREFIX_PATH=${root_cmake}
   INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/go4/go4login ${CMAKE_BINARY_DIR}
)

ExternalProject_Add(
   STREAM
   SOURCE_DIR ${CMAKE_SOURCE_DIR}/stream
   BUILD_ALWAYS 1
   BINARY_DIR stream
   DEPENDS GO4 ${root_dep}
   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${root_cmake}$<SEMICOLON>${CMAKE_BINARY_DIR}/go4
   INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/stream/streamlogin ${CMAKE_BINARY_DIR}
)

ExternalProject_Add(
   DABC
   SOURCE_DIR ${CMAKE_SOURCE_DIR}/dabc
   BUILD_ALWAYS 1
   BINARY_DIR dabc
   DEPENDS ${root_dep} GO4 STREAM
   CMAKE_ARGS -DCMAKE_PREFIX_PATH=${root_cmake}$<SEMICOLON>${CMAKE_BINARY_DIR}/go4$<SEMICOLON>${CMAKE_BINARY_DIR}/stream
   INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/dabc/dabclogin ${CMAKE_BINARY_DIR}
)

configure_file(${CMAKE_SOURCE_DIR}/scripts/dabcgo4login.in
              ${CMAKE_BINARY_DIR}/dabcgo4login @ONLY NEWLINE_STYLE UNIX)
