include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
define discoverBibtexFiles
$(shell \
	$(GREP) -E '\\bibliography\s*{' $(1) 2> /dev/null  \
		| $(removeTexComments) \
		| $(SED) 's/.*\\bibliography//' \
		| $(SED) 's/\.bib//g' \
		| $(TR) "," "\n" \
		| $(TR) -d "{}" \
		| $(SED) 's/\s*$$/.bib /' \
		| $(SORT) \
		| $(UNIQ) \
)
endef

# For converting document formats
BIBTEX ?= bibtex

# =======================
# Bibliography generation
# =======================
#
# This generates a `bbl` file from a  `bib` file For documents without a `bib`
# file, this  will also be  targeted, bit  the '-' before  the `$(BIBTEX)`
# ensures that the whole building doesn't fail because of it
#
$(BIBITEM_FILES): $(BIBTEX_FILES)
	$(ARROW) "Compiling the bibliography"
	-$(DBG_FLAG)test $(BUILD_DIR) = . || { \
		for bibfile in $(BIBTEX_FILES); do \
			mkdir -p $(BUILD_DIR)/$$(dirname $$bibfile); \
			cp -u $$bibfile $(BUILD_DIR)/$$(dirname $$bibfile); \
		done \
		}
	$(ECHO) $(call print-cmd-name,$(BIBTEX)) $@
	$(DBG_FLAG)cd $(BUILD_DIR); $(BIBTEX) $(patsubst %.tex,%,$(MAIN_SRC)) $(FD_OUTPUT)
	$(ARROW) Compiling again $(BUILD_DOCUMENT) to update refs
	$(DBG_FLAG)$(MAKE) --no-print-directory force

dnl vim:ft=make:noexpandtab:
