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
set(VALA_OPTIONS "")
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

# Precompile the C-files from Vala compiler and place them into "VALA_C".
vala_precompile(VALA_C ${SOURCES}
                PACKAGES ${VALA_PACKAGES}
                OPTIONS ${VALA_OPTIONS})

# Add the executable compiled from the generated Vala C-files. The C-files were
# previously stored from vala_precompile() in variable "VALA_C".
add_executable("gamebox" ${VALA_C})

# Compile resources if any.
if (${RESOURCES})
    # TODO: Use a configuration.vala.in file to put in there the name of the
    #       resource file so it can be used in the resource manager.
    compile_gresources(RESOURCE_OUT
                       TYPE BUNDLE
                       TARGET "resources.gresource"
                       RESOURCES ${RESOURCES})

    # Create a separate target "resources" that is run with the "all" target.
    add_custom_target(resources
                      ALL
                      DEPENDS ${RESOURCE_OUT})
endif()
