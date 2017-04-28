
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
	$(DEBUG)mkdir -p $(BUILD_DIR)
	$(DEBUG)cp $^ $@
