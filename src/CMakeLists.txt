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
)

# Include Vala macros.
include(FindVala)
include(UseVala)

# Find and configure needed packages.
# - Vala
find_package(Vala 0.26 REQUIRED)
# - Gtk3 Vala package
find_package(PkgConfig)
pkg_check_modules(GTK REQUIRED gtk+-3.0)
add_definitions(${GTK_CFLAGS} ${GTK_CFLAGS_OTHER})
link_libraries(${GTK_LIBRARIES})
link_directories(${GTK_LIBRARY_DIRS})

# Add the main sources.
list(APPEND SOURCES
    gamebox.vala
)

# Add all source subdirectories.
add_subdirectory(GameBox)

# Configure needed Vala packages.
set(VALA_PACKAGES "gtk+-3.0")

# Precompile the C-files from Vala compiler and place them into "VALA_C".
vala_precompile(VALA_C ${SOURCES} PACKAGES ${VALA_PACKAGES})

# Add the executable compiled from the generated Vala C-files. The C-files were
# previously stored from vala_precompile() in variable "VALA_C".
add_executable("gamebox" ${VALA_C})