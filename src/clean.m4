# File to be cleaned
CLEAN_FILES ?= \
$(wildcard $(PACKAGES_FILES_BUILD)) \
$(wildcard $(PYTHONTEX_FILE)) \
$(wildcard $(BUILD_DOCUMENT)) \
$(wildcard $(subst %,*,$(PURGE_SUFFIXES))) \
$(wildcard $(subst %,$(patsubst %.tex,%,$(MAIN_SRC)),$(SUPPORTED_SUFFIXES))) \
$(wildcard $(DEPS_DIR)) \
$(wildcard $(PDFPC_FILE)) \
$(wildcard $(DIST_DIR)) \
$(wildcard $(DIFF_BUILD_DIR_MAIN)) \
$(wildcard $(DIFF_SRC_NAME)) \
$(if $(filter-out .,$(strip $(BUILD_DIR))),$(wildcard $(BUILD_DIR))) \

# =============
# Main cleaning
# =============
#
# This does a main cleaning of the produced auxiliary files.  Before using it
# check which files are going to be cleaned up.
#
clean: ## Remove build and temporary files
	$(ARROW) Cleaning up...
	$(DEBUG){ for file in $(CLEAN_FILES); do echo "  *  $$file"; done }
	$(DEBUG)rm -rf $(CLEAN_FILES)
