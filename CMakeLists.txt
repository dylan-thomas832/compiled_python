cmake_minimum_required(VERSION 3.15...3.26)
project(${SKBUILD_PROJECT_NAME} LANGUAGES CXX)

include( GNUInstallDirs )

if(${SKBUILD})
  set(CMAKE_INSTALL_PREFIX ${SKBUILD_PLATLIB_DIR}/${SKBUILD_PROJECT_NAME})
endif()

find_package(
  Python
  COMPONENTS Interpreter Development.Module
  REQUIRED)

find_package(
  SWIG
  COMPONENTS python
  REQUIRED)

include(UseSWIG)

set(SRC interface/example.i)
set_property(SOURCE ${SRC} PROPERTY CPLUSPLUS ON)

add_library(libexample SHARED lib/example.cpp)

swig_add_library(
  example
  LANGUAGE python
  TYPE SHARED
  OUTPUT_DIR ${CMAKE_INSTALL_PREFIX}
  SOURCES ${SRC})

set_target_properties(
  example PROPERTIES
  SUFFIX ".${Python_SOABI}${CMAKE_SHARED_MODULE_SUFFIX}"
  SWIG_USE_TARGET_INCLUDE_DIRECTORIES TRUE
)
set_property(TARGET
  example APPEND PROPERTY
  INSTALL_RPATH "$ORIGIN"
)

target_include_directories(example PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/lib)
target_link_libraries(example PRIVATE Python::Module libexample)

install(TARGETS libexample DESTINATION ${CMAKE_INSTALL_PREFIX})
install(TARGETS example DESTINATION ${CMAKE_INSTALL_PREFIX})
