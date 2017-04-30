include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
# For checking tex syntax
TEX_LINTER ?= chktex

# ============
# Check syntax
# ============
#
# It checks the syntax (lints) of all the tex sources using the program in the
# TEX_LINTER variable.
#
lint: $(TEXFILES) ## Check syntax of latex sources (TEX_LINTER)
	$(TEX_LINTER) $(TEXFILES)

dnl vim: noexpandtab
