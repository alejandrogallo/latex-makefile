#PANDOC CONVERSIONS
###################

PANDOC ?= pandoc

# FIXME: It doesn't work out of the box
#
# ======================
# Reveal.js presentation
# ======================
#
# This creates a revealjs presentation using the the pandoc program stored in
# the make variable PANDOC.
#
revealjs: $(MAIN_SRC)
	$(ARROW) Creating revealjs presentation...
	$(ARROW) Gettin revealjs from $(REVEALJS_SRC)
	$(GIT) clone --depth=1 $(REVEALJS_SRC) && rm -rf reveal.js/.git
	$(PANDOC) --mathjax -s -f latex -t revealjs $(MAIN_SRC) -o $(BUILD_DOCUMENT)
REVEALJS_SRC ?= https://github.com/hakimel/reveal.js/

# =================
# Unix man document
# =================
#
# This creates a man page using `pandoc`.
#
man: $(MAIN_SRC)
	$(ARROW) $(call print-cmd-name,$(PANDOC)) $(BUILD_DOCUMENT)
	$(PANDOC) -s -f latex -t man $(MAIN_SRC) -o $(BUILD_DOCUMENT)

# =============
# HTML document
# =============
#
# This creates an html page using `pandoc`.
#
html: $(MAIN_SRC)
	$(ARROW) $(call print-cmd-name,$(PANDOC)) $(BUILD_DOCUMENT)
	$(PANDOC) --mathjax -s -f latex -t html5 $(MAIN_SRC) -o $(BUILD_DOCUMENT)

dnl vim: noexpandtab
