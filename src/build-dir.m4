include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
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
	$(ECHO) $(call print-cmd-name,mkdir) $@
	$(DBG_FLAG)mkdir -p $@ $(FD_OUTPUT)
	$(DBG_FLAG)for i in $(TEXFILES); do \
		mkdir -p $@/$$(dirname $$i); \
	done $(FD_OUTPUT)



dnl vim:ft=make:noexpandtab:
