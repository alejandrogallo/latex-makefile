include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
# ====================================
# Ctags generation for latex documents
# ====================================
#
# Generate a tags  file so that you can navigate  through the tags using
# compatible editors such as emacs or (n)vi(m).
#
tags: $(TEXFILES) ## Create TeX exhuberant ctags
	$(CTAGS) --language-force=tex -R *

dnl vim: noexpandtab
