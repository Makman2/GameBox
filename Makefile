# This file is part of GameBox. License: GPL3

# Defines the build directory of GameBox.
GAMEBOX_BUILD_DIR = build
# Defines the debug/release build folders. They are appended to the build path
# (GAMEBOX_BUILD_DIR).
GAMEBOX_BUILD_DEBUG_DIR = debug
GAMEBOX_BUILD_RELEASE_DIR = release
# Defines the source directory relative to GAMEBOX_BUILD_DIR and the
# debug/release build path (GAMEBOX_BUILD_DEBUG_DIR and
# GAMEBOX_BUILD_RELEASE_DIR).
GAMEBOX_SOURCE_FROM_DEBUG_BUILD = ../../src
GAMEBOX_SOURCE_FROM_RELEASE_BUILD = ../../src
# Make flags passed to the generated makefile at invocation.
GAMEBOX_MAKE_FLAGS = --no-print-directory

# Fetch the path to the CMake executable to invoke it.
CMAKE := $(shell which cmake)
# Flags to pass to CMake at invocation. Build type independent.
CMAKE_GENERAL_FLAGS =
# Flags to pass to CMake when building for debug/release.
CMAKE_DEBUG_FLAGS = -DCMAKE_BUILD_TYPE=Debug
CMAKE_RELEASE_FLAGS = -DCMAKE_BUILD_TYPE=Release

help:
	@echo "No target chosen. Possible targets are:"
	@echo "  debug    Builds the GameBox application (debug build)."
	@echo "  release  Builds the GameBox application (release build)."
	@echo "  run      Runs the GameBox application (gamebox) in the build"
	@echo "           directory."
	@echo "  clean    Cleans all build files."
	@echo ""
	@echo "  help     Displays this help."

$(GAMEBOX_BUILD_DIR):
	@if ! test -d $(GAMEBOX_BUILD_DIR);       \
     then                                     \
      echo -n "Creating build directory... "; \
      mkdir -p $(GAMEBOX_BUILD_DIR);          \
      echo "Done.";                           \
     fi

debug: $(GAMEBOX_BUILD_DIR)
	@cd $(GAMEBOX_BUILD_DIR);                 \
     if ! test -d $(GAMEBOX_BUILD_DEBUG_DIR); \
     then                                     \
      echo -n "Creating debug directory... "; \
      mkdir -p $(GAMEBOX_BUILD_DEBUG_DIR);    \
      echo "Done.";                           \
     fi
	@echo "Invoking CMake (Debug build)."
	@cd $(GAMEBOX_BUILD_DIR)/$(GAMEBOX_BUILD_DEBUG_DIR);                \
     $(CMAKE) $(GAMEBOX_SOURCE_FROM_DEBUG_BUILD) $(CMAKE_GENERAL_FLAGS) \
     $(CMAKE_DEBUG_FLAGS)
	@echo "Building GameBox..."
	@$(MAKE) -C $(GAMEBOX_BUILD_DIR)/$(GAMEBOX_BUILD_DEBUG_DIR) \
             $(GAMEBOX_MAKE_FLAGS)
	@echo "Done."

release: $(GAMEBOX_BUILD_DIR)
	@cd $(GAMEBOX_BUILD_DIR);                   \
     if ! test -d $(GAMEBOX_BUILD_RELEASE_DIR); \
     then                                       \
      echo -n "Creating release directory... "; \
      mkdir -p $(GAMEBOX_BUILD_RELEASE_DIR);    \
      echo "Done.";                             \
     fi
	@echo "Invoking CMake (Release build)."
	@cd $(GAMEBOX_BUILD_DIR)/$(GAMEBOX_BUILD_RELEASE_DIR);                \
     $(CMAKE) $(GAMEBOX_SOURCE_FROM_RELEASE_BUILD) $(CMAKE_GENERAL_FLAGS) \
     $(CMAKE_RELEASE_FLAGS)
	@echo "Building GameBox..."
	@$(MAKE) -C $(GAMEBOX_BUILD_DIR)/$(GAMEBOX_BUILD_RELEASE_DIR) \
             $(GAMEBOX_MAKE_FLAGS)
	@echo "Done."

run:
	@cd $(GAMEBOX_BUILD_DIR); \
     ./gamebox

clean:
	@if test -d $(GAMEBOX_BUILD_DIR);       \
     then                                   \
      echo -n "Cleaning up... ";            \
      rm -rf $(GAMEBOX_BUILD_DIR);          \
      echo "Done.";                         \
     else                                   \
      echo "Already clean. Nothing to do."; \
     fi
