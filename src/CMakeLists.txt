# This file is part of GameBox. License: GPL3

cmake_minimum_required(VERSION 2.8)

# Create project.
project("GameBox" C)

# Version.
set(GameBox_VERSION_MAJOR 0)
set(GameBox_VERSION_MINOR 1)
set(GameBox_VERSION_MICRO 0)

# Add the Vala CMake macro-directory from submodule jakobwesthoff/Vala_CMake to
# the CMake module list.
list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/../submodules/Vala_CMake/vala
    ${CMAKE_SOURCE_DIR}/../submodules/GCR_CMake/macros
)

# Include Vala macros.
include(FindVala)
include(UseVala)
# Include GCR macros (for resource compilation).
include(GlibCompileResourcesSupport)

# Find and configure needed packages.
# - Vala
find_package(Vala 0.26 REQUIRED)
# - Gtk3 Vala package
find_package(PkgConfig)
pkg_check_modules(GTK REQUIRED gtk+-3.0)
add_definitions(${GTK_CFLAGS} ${GTK_CFLAGS_OTHER})
link_libraries(${GTK_LIBRARIES})
link_directories(${GTK_LIBRARY_DIRS})

# Configure Vala options (i.e. debug/release mode).
set(VALA_OPTIONS "--target-glib=2.38")
if ("${CMAKE_BUILD_TYPE}" STREQUAL "debug")
    list(APPEND VALA_OPTIONS "--debug")
endif()

# Add the main sources.
list(APPEND SOURCES
    gamebox.vala
)

# Add all source subdirectories.
add_subdirectory(GameBox)

# Configure needed Vala packages.
set(VALA_PACKAGES "gtk+-3.0")

# Compile resources if any.
if (RESOURCES)
    compile_gresources(RESOURCE_OUT
                       XML_OUT
                       TYPE BUNDLE
                       TARGET ${CMAKE_BINARY_DIR}/resources.gresource
                       RESOURCES ${RESOURCES})

    # Create a separate target "resources" that is run with the "all" target.
    add_custom_target(resources
                      ALL
                      DEPENDS ${RESOURCE_OUT})

    # Copy the xml resource file to the source directory so Vala can identify
    # the resources relative to the XML file paths in the source directory.
    # Otherwise it would take them relatively to build directory.
    get_filename_component(XML_FILE_NAME ${XML_OUT} NAME)
    add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/${XML_FILE_NAME}
                       COMMAND cp
                       ARGS
                           ${XML_OUT}
                           ${CMAKE_SOURCE_DIR}
                       DEPENDS ${XML_OUT}
                       COMMENT "Copy ${XML_FILE_NAME} to source directory")

    add_custom_target(copy_resources_xml
                      ALL
                      DEPENDS ${CMAKE_SOURCE_DIR}/${XML_FILE_NAME})

    list(APPEND VALA_OPTIONS
         "--gresources=${CMAKE_SOURCE_DIR}/${XML_FILE_NAME}")

endif()

# Configure build configuration.
string(REPLACE "${CMAKE_BINARY_DIR}/" "" GameBox_RESOURCE_RELATIVE_TO_EXE
       ${RESOURCE_OUT})
configure_file(${CMAKE_CURRENT_LIST_DIR}/GameBox/BuildConfiguration.vala.in
               ${CMAKE_CURRENT_LIST_DIR}/GameBox/BuildConfiguration.vala)
# Process configured file name to add to the vala sources.
string(REPLACE "${PROJECT_SOURCE_DIR}" "" CMAKE_CURRENT_LIST_DIR_RELATIVE
               "${CMAKE_CURRENT_LIST_DIR}")
list(APPEND SOURCES
     ${CMAKE_CURRENT_LIST_DIR_RELATIVE}/GameBox/BuildConfiguration.vala)

# Precompile the C-files from Vala compiler and place them into "VALA_C".
vala_precompile(VALA_C
                SOURCES ${SOURCES}
                PACKAGES ${VALA_PACKAGES}
                OPTIONS ${VALA_OPTIONS})

# Add the executable compiled from the generated Vala C-files. The C-files were
# previously stored from vala_precompile() in variable "VALA_C".
add_executable("gamebox" ${VALA_C})

# Make the resources xml copy target dependent from the executable, since the
# copy is needed by valac directly for --gresources. The resource file itself
# is not needed at compilation stage, only for runtime.
if (RESOURCES)
    add_dependencies(gamebox copy_resources_xml)
endif()
