include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
.PHONY: diff
# For creating differences in a repository
LATEXDIFF ?= latexdiff-git
# Commits to compute the difference from
DIFF ?=HEAD HEAD~1
NEW_COMMIT = $(word 1,$(DIFF))
OLD_COMMIT = $(word 2,$(DIFF))
DIFF_BUILD_DIR_MAIN ?= diffs
DIFF_BUILD_DIR ?= $(DIFF_BUILD_DIR_MAIN)/$(NEW_COMMIT)_$(OLD_COMMIT)
DIFF_SRC_NAME  ?= diff.tex
# ====
# Diff
# ====
#
# This target creates differences between older versions of the main latex file
# by means of [GIT](https://git-scm.com/). You have to specify the commits that
# you want to compare by doing
#
# ```bash
# make DIFF="HEAD HEAD~3" diff
# ```
# If you want to compare the HEAD commit with the commit three times older than
# HEAD. You can also provide a *commit hash*. The default value is `HEAD HEAD~1`.
#
# The target creates a distribution folder located in the variable
# `DIFF_BUILD_DIR`.
diff: ## Create a latexdiff using git versions
	$(ARROW) Creating diff between $(NEW_COMMIT) and $(OLD_COMMIT)
	$(DBG_FLAG){ \
		temp=$$(mktemp -d); \
		$(LATEXDIFF) \
			-r $(NEW_COMMIT) \
			-r $(OLD_COMMIT) $(MAIN_SRC) -d $${temp} $(FD_OUTPUT); \
		cp $${temp}/$(MAIN_SRC) $(DIFF_SRC_NAME); \
	} $(FD_OUTPUT)
	$(ARROW) Building in $(DIFF_BUILD_DIR)
	$(DBG_FLAG)$(MAKE) dist \
		BUILD_DIR=$(DIFF_BUILD_DIR) \
		MAIN_SRC=$(DIFF_SRC_NAME) \
		DIST_DIR=$(DIFF_BUILD_DIR)





dnl vim: noexpandtab ft=make
