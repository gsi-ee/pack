cmake_minimum_required(VERSION 3.13 FATAL_ERROR)

project(Pack)

include(ExternalProject)


ExternalProject_Add(
   STREAM
   SOURCE_DIR ${CMAKE_SOURCE_DIR}/stream
   BINARY_DIR stream
   INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_BINARY_DIR}/stream/streamlogin ${CMAKE_BINARY_DIR}
)
