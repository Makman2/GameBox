# This file is part of GameBox. License: GPL3

# Since the Vala CMake macros can only deal with relative paths, we construct
# the relative path to this CMakeLists.txt ourself.
string(REPLACE "${PROJECT_SOURCE_DIR}/" "" CMAKE_CURRENT_LIST_DIR_RELATIVE
               "${CMAKE_CURRENT_LIST_DIR}")

list(APPEND SOURCES
    ${CMAKE_CURRENT_LIST_DIR_RELATIVE}/ApplicationWindow.vala
)

list(APPEND RESOURCES
    ${CMAKE_CURRENT_LIST_DIR_RELATIVE}/ApplicationWindow.ui
)

# Append to parent variable.
set(SOURCES "${SOURCES}" PARENT_SCOPE)
set(RESOURCES "${RESOURCES}" PARENT_SCOPE)
