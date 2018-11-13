include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl

# Options for ctags command
CTAGS_OPTIONS ?= --language-force=latex -R *

dnl
# ====================================
# Ctags generation for latex documents
# ====================================
#
# Generate a tags  file so that you can navigate  through the tags using
# compatible editors such as emacs or (n)vi(m).
#
tags: $(TEXFILES) ## Create TeX exhuberant ctags
	$(CTAGS) $(CTAGS_OPTIONS)

dnl vim:ft=make:noexpandtab:
