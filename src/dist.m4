include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
# Distribution directory
DIST_DIR ?= dist

# ============
# Distribution
# ============
#
# Create a distribution folder wit the bare minimum to compile your project.
# For example it will consider the files in the DEPENDENCIES variable, so make
# sure to update or add DEPENDENCIES to it in the config.mk per user
# configuration.
#
dist: $(BUILD_DOCUMENT) ## Create a dist folder with the bare minimum to compile
	$(ECHO) $(call print-cmd-name,mkdir) $(DIST_DIR)
	$(DBG_FLAG)mkdir -p $(DIST_DIR)
	$(ECHO) $(call print-cmd-name,cp) $(DIST_DIR)/Makefile
	$(DBG_FLAG)cp Makefile $(DIST_DIR)/
	$(ECHO) $(call print-cmd-name,cp) $(DIST_DIR)/$(BUILD_DOCUMENT)
	$(DBG_FLAG)cp $(BUILD_DOCUMENT) $(DIST_DIR)/
	$(ARROW) "Copying bib files"
	$(DBG_FLAG)test -n "$(BIBTEX_FILES)" && {\
		for bibfile in $(BIBTEX_FILES); do \
			mkdir -p $(DIST_DIR)/$$(dirname $$bibfile); \
			cp -u $$bibfile $(DIST_DIR)/$$(dirname $$bibfile); \
		done \
		} || echo "No bibfiles"
	$(ARROW) "Creating folder for dependencies"
	$(DBG_FLAG)echo $(DEPENDENCIES)\
		| $(XARGS) -n1 dirname\
		| $(XARGS) -n1 -I FF mkdir -p $(DIST_DIR)/FF
	$(ARROW) "Copying dependencies"
	-$(DBG_FLAG)echo $(DEPENDENCIES)\
		| $(TR) " " "\n" \
		| $(XARGS) -n1 -I FF cp -r FF $(DIST_DIR)/FF
ifneq ($(strip $(PACKAGES_FILES)),)
	$(ARROW) "Creating folder for latex libraries"
	$(DBG_FLAG)test -n "$(PACKAGES_FILES)" && echo $(PACKAGES_FILES)\
		| $(XARGS) -n1 dirname\
		| $(XARGS) -n1 -I FF mkdir -p $(DIST_DIR)/FF
	$(ARROW) "Copying latex libraries"
	$(DBG_FLAG)test -n "$(PACKAGES_FILES)" && echo $(PACKAGES_FILES)\
		| $(TR) " " "\n" \
		| $(XARGS) -n1 -I FF cp FF $(DIST_DIR)/FF
endif

# ==================
# Distribution clean
# ==================
#
# Clean distribution files
#
dist-clean: CLEAN_FILES=$(DIST_DIR) ## Clean distribution files
dist-clean: clean

