$(BUILD_DIR):
	$(ARROW) Creating the $@ directory
	$(DEBUG)mkdir -p $@ $(FD_OUTPUT)

$(BUILD_DIR)/%: $(PACKAGES_DIR)/%
	$(ARROW) Copying TeX libraries: $@
	$(DEBUG)mkdir -p $(BUILD_DIR)
	$(DEBUG)cp $^ $@

dnl vim: noexpandtab
