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
# DIFF_BUILD_DIR. *Warning*: It only works for single document tex projects.
diff: ## Create a latexdiff using git versions
	$(ARROW) Creating diff between $(NEW_COMMIT) and $(OLD_COMMIT)
	$(DEBUG)mkdir -p $(DIFF_BUILD_DIR)
	git checkout $(NEW_COMMIT) $(MAIN_SRC)
	cp $(MAIN_SRC) $(DIFF_BUILD_DIR)/$(strip $(MAIN_SRC)).$(NEW_COMMIT)
	git checkout $(OLD_COMMIT) $(MAIN_SRC)
	cp $(MAIN_SRC) $(DIFF_BUILD_DIR)/$(strip $(MAIN_SRC)).$(OLD_COMMIT)
	$(LATEXDIFF) \
		$(DIFF_BUILD_DIR)/$(strip $(MAIN_SRC)).$(OLD_COMMIT) \
		$(DIFF_BUILD_DIR)/$(strip $(MAIN_SRC)).$(NEW_COMMIT) \
		> $(DIFF_SRC_NAME)
	$(MAKE) dist \
		BUILD_DIR=$(DIFF_BUILD_DIR) \
		MAIN_SRC=$(DIFF_SRC_NAME) \
		DIST_DIR=$(DIFF_BUILD_DIR)
	rm $(DIFF_SRC_NAME) $(patsubst %.tex,%.pdf,$(DIFF_SRC_NAME))
	git checkout HEAD $(MAIN_SRC)

dnl vim: noexpandtab
