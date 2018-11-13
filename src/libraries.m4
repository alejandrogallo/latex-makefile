include_once(build-dir.m4)dnl
include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
# Tex libraries directory
PACKAGES_DIR ?= libtex

# Which files are tex libraries
PACKAGES_FILES  ?= $(wildcard \
$(PACKAGES_DIR)/*.sty \
$(PACKAGES_DIR)/*.rtx \
$(PACKAGES_DIR)/*.cls \
$(PACKAGES_DIR)/*.bst \
$(PACKAGES_DIR)/*.tex \
$(PACKAGES_DIR)/*.clo \
)

$(BUILD_DIR)/%: $(PACKAGES_DIR)/%
	$(ECHO) $(call print-cmd-name,CP) $@
	$(DBG_FLAG)mkdir -p $(BUILD_DIR)
	$(DBG_FLAG)cp $^ $@
dnl vim:ft=make:noexpandtab:
