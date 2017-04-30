include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
# Folder to build the project
BUILD_DIR ?= .

# Build dir flag for latex.
# If `BUILD_DIR = .` then `BUILD_DIR_FLAG` is not defined,
# else `BUILD_DIR = -output-directory $(BUILD_DIR)`
BUILD_DIR_FLAG  ?= $(if \
                   $(filter-out \
                   .,$(strip $(BUILD_DIR))),-output-directory $(BUILD_DIR))

$(BUILD_DIR):
	$(ARROW) Creating the $@ directory
	$(DBG_FLAG)mkdir -p $@ $(FD_OUTPUT)


dnl vim: noexpandtab
