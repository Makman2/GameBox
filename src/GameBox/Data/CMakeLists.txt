# This file is part of GameBox. License: GPL3

# Since the Vala CMake macros can only deal with relative paths, we construct
# the relative path to this CMakeLists.txt ourself.
string(REPLACE "${PROJECT_SOURCE_DIR}/" "" CMAKE_CURRENT_LIST_DIR_RELATIVE
               "${CMAKE_CURRENT_LIST_DIR}")

list(APPEND SOURCES
    ${CMAKE_CURRENT_LIST_DIR_RELATIVE}/IDataStreamReadable.vala
    ${CMAKE_CURRENT_LIST_DIR_RELATIVE}/DataStreamReadableBase.vala
    ${CMAKE_CURRENT_LIST_DIR_RELATIVE}/IDataStreamWritable.vala
    ${CMAKE_CURRENT_LIST_DIR_RELATIVE}/DataStreamWritableBase.vala
)

# Append to parent variable.
set(SOURCES "${SOURCES}" PARENT_SCOPE)

