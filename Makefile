# This file is part of GameBox. License: GPL3

# Defines the build directory of GameBox.
GAMEBOX_BUILD_DIR = build
# Defines the source directory relative from GAMEBOX_BUILD_DIR.
GAMEBOX_SOURCE_FROM_BUILD = ../src
# Make flags passed to the generated makefile at invocation.
GAMEBOX_MAKE_FLAGS = --no-print-directory

CMAKE := $(shell which cmake)
# Flags to pass to CMake at invocation.
CMAKE_FLAGS =

help:
	@echo "No target chosen. Possible targets are:"
	@echo "  build    Builds the GameBox application."
	@echo "  run      Runs the GameBox application (gamebox) in the build"
	@echo "           directory."
	@echo "  clean    Cleans all build files."
	@echo ""
	@echo "  help     Displays this help."

build:
	@if ! test -d $(GAMEBOX_BUILD_DIR);       \
     then                                     \
      echo -n "Creating build directory... "; \
      mkdir -p $(GAMEBOX_BUILD_DIR);          \
      echo "Done.";                           \
     fi
	@echo "Invoking CMake."
	@cd $(GAMEBOX_BUILD_DIR);                             \
     $(CMAKE) $(GAMEBOX_SOURCE_FROM_BUILD) $(CMAKE_FLAGS)
	@echo "Building GameBox..."
	@$(MAKE) -C $(GAMEBOX_BUILD_DIR) $(GAMEBOX_MAKE_FLAGS)
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
