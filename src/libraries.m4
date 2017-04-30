include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
# Tex libraries directory
PACKAGES_DIR    ?= libtex

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
	$(ARROW) Copying TeX libraries: $@
	$(DBG_FLAG)mkdir -p $(BUILD_DIR)
	$(DBG_FLAG)cp $^ $@
