include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
# Recognise pdf viewer automagically
PDF_VIEWER ?= $(or \
$(shell $(WHICH) zathura 2> /dev/null),\
$(shell $(WHICH) mupdf 2> /dev/null),\
$(shell $(WHICH) mupdf-x11 2> /dev/null),\
$(shell $(WHICH) mupdf-gl 2> /dev/null),\
$(shell $(WHICH) evince 2> /dev/null),\
$(shell $(WHICH) okular 2> /dev/null),\
$(shell $(WHICH) xdg-open 2> /dev/null),\
$(shell $(WHICH) gnome-open 2> /dev/null),\
$(shell $(WHICH) kde-open 2> /dev/null),\
$(shell $(WHICH) open 2> /dev/null),\
)

# =============
# View document
# =============
#
# Open and refresh pdf.
#
view-pdf: $(PDF_VIEWER) open-pdf ## Refresh and open pdf

# ===============
# Open pdf viewer
# ===============
#
# Open a viewer if there is none open viewing `$(BUILD_DOCUMENT)`
#
open-pdf: $(BUILD_DOCUMENT) ## Open pdf build document
	$(ECHO) $(call print-cmd-name,$(PDF_VIEWER)) $(BUILD_DOCUMENT)
	-$(DBG_FLAG)ps aux | $(GREP) -v $(GREP) \
	| $(GREP) "$(PDF_VIEWER)" \
	| $(GREP) -q "$(BUILD_DOCUMENT)" \
	||  $(PDF_VIEWER) "$(BUILD_DOCUMENT)" 2>&1 > /dev/null &

# =============
# Refresh mupdf
# =============
#
# If the opened document is being viewed with `mupdf` this target uses the
# mupdf signal API to refresh the document.
#
mupdf /usr/bin/mupdf: ## Refresh mupdf
	-$(DBG_FLAG)ps aux \
	| $(GREP) -v $(GREP) \
	| $(GREP) "$(PDF_VIEWER)" \
	| $(GREP) "$(BUILD_DOCUMENT)" \
	| $(AWK) '{print $$2}'\
	| { read pid; test -z "$$pid" || kill -s HUP $$pid; }


dnl vim: noexpandtab
include_once(os.m4)
