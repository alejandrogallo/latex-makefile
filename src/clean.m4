include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
# Remove command
RM ?= rm
RM_FLAGS ?= -rf

# Default clean file to be cleaned
DEFAULT_CLEAN_FILES = \
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

# Files to be cleaned
CLEAN_FILES ?= $(DEFAULT_CLEAN_FILES)

# =============
# Main cleaning
# =============
#
# This does a main cleaning of the produced auxiliary files.  Before using it
# check which files are going to be cleaned up.
#
clean: ## Remove build and temporary files
	$(ARROW) Cleaning up...
	$(DBG_FLAG) {\
		for file in $(CLEAN_FILES); do \
			test -e $$file && { \
				$(RM) $(RM_FLAGS) $$file &&      \
				echo $(call print-cmd-name,RM) "$$file";\
		 } || : ; \
		done \
	}

dnl vim: noexpandtab
