include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
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
revealjs: reveal.js $(TEXFILES)
	$(ARROW) Creating revealjs presentation...
	$(DBG_FLAG)$(PANDOC) \
		--mathjax -s \
		-f latex -t revealjs \
		--section-divs \
		--variable theme="$(REVEALJS_THEME)" \
		--variable transition="$(REVEALJS_TRANSITION)" \
		$(MAIN_SRC) -o $(BUILD_DOCUMENT)

reveal.js:
	$(ARROW) Gettin revealjs from $(REVEALJS_SRC)
	$(DBG_FLAG)$(GIT) clone --depth=1 $(REVEALJS_SRC) && \
		rm -rf reveal.js/.git && \
		cp reveal.js/js/reveal.js reveal.js/js/reveal.min.js && \
		cp reveal.js/css/reveal.css reveal.js/css/reveal.min.css


# (beige black blood league moon night serif simple sky solarized white)
REVEALJS_THEME ?= solarized
REVEALJS_TRANSITION ?= linear
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
