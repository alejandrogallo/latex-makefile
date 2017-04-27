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
	-$(DEBUG)test $(BUILD_DIR) = . || { \
		for bibfile in $(BIBTEX_FILES); do \
			mkdir -p $(BUILD_DIR)/$$(dirname $$bibfile); \
			cp -u $$bibfile $(BUILD_DIR)/$$(dirname $$bibfile); \
		done \
		}
	$(DEBUG)cd $(BUILD_DIR); $(BIBTEX) $(patsubst %.tex,%,$(MAIN_SRC)) $(FD_OUTPUT)
	$(ARROW) Compiling again $(BUILD_DOCUMENT) to update refs
	$(DEBUG)$(MAKE) --no-print-directory force
