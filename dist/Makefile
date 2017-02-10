## <<HELP
#
#                           The ultimate
#  _    ____ ___ ____ _  _    _  _ ____ _  _ ____ ____ _ _    ____
#  |    |__|  |  |___  \/     |\/| |__| |_/  |___ |___ | |    |___
#  |___ |  |  |  |___ _/\_    |  | |  | | \_ |___ |    | |___ |___
#
#
#
## HELP

# Local configuration
-include config.mk

# Recognise OS
ifeq ($(shell uname),Linux)
LINUX := 1
OSX   :=
else
LINUX :=
OSX   := 1
endif


# PARAMETERS, OVERRIDE THESE
############################

# Shell utilities
LATEX      ?= pdflatex
# For creating differences
LATEXDIFF  ?= latexdiff
# For checking tex syntax
TEX_LINTER ?= chktex
PDFLATEX   ?= pdflatex
# For asymptote figures
ASYMPTOTE  ?= asy
# Gnuplot interpreter
GNUPLOT    ?= gnuplot
# For converting document formats
PANDOC     ?= pandoc
BIBTEX     ?= bibtex
# Shell used
SH         ?= bash
# Python interpreter
PY         ?= python
PYTHONTEX  ?= pythontex
# Grep program version
GREP       ?= grep
# sed program version
SED        ?= $(if $(OSX),gsed,sed)
AWK        ?= $(if $(OSX),gawk,awk)
# For creating tags
CTAGS      ?= ctags
# To get complete paths
READLINK   ?= $(if $(OSX),greadlink,readlink)
XARGS      ?= xargs
TR         ?= tr
GIT        ?= git
WHICH      ?= which
# For coloring
TPUT       ?= $(shell $(WHICH) tput 2> /dev/null)
# If messages should have color
WITH_COLOR ?= 1
# If the main messages should be also muted
QQUIET     ?=
DEBUG      ?= @

ifndef QQUIET

ifeq ($(strip $(WITH_COLOR)),1)
COLOR_B         ?= $(if $(TPUT),$(shell $(TPUT) setaf 5),"\033[0;35m")
ECHO            ?= @echo "$(COLOR_B)===>\033[0m"
else
ECHO            ?= @echo "===>"
endif #WITH_COLOR

else
ECHO            := @ > /dev/null echo
endif #QQUIET

# Function to try to discover automatically
# the main latex document
discoverMain = $(shell \
                   $(GREP) -H '\\begin{document}' *.tex 2>/dev/null \
                   | head -1 \
                   | $(AWK) -F ":" '{print $$1}')

hasToc = $(shell\
             $(GREP) '\\tableofcontents' $(1))

# Man texfile in the current directory
MAIN_SRC        ?= $(call discoverMain)
# Format to build to
FMT             ?= pdf
# Bibtex files in the current directory
BIBTEX_FILE     ?= $(wildcard *.bib)
# Folder to keep makefile dependencies
DEPS_DIR        ?= .deps
# Folder to build the project
BUILD_DIR       ?= .
# If pdf should be previewed after building
VIEW_PDF        ?= 1
# General dependencies for BUILD_DOCUMENT
DEPENDENCIES    ?=
# File to be cleaned
CLEAN_FILES     ?=
# Figures included in all texfiles
FIGURES         ?=
# Texfiles included in the main tex file
INCLUDES        ?=
# If pythontex is being used
WITH_PYTHONTEX  ?=
# If secondary programs output is shown
QUIET           ?= 0
# Source directory
PREFIX          ?= $(PWD)
# Distribution directory
DIST_DIR        ?= $(PREFIX)/dist
# Tex libraries directory
PACKAGES_DIR    ?= libtex
# Which files are tex libraries
PACKAGES_FILES  ?= $(wildcard \
$(PACKAGES_DIR)/*.sty \
$(PACKAGES_DIR)/*.rtx \
$(PACKAGES_DIR)/*.cls \
$(PACKAGES_DIR)/*.bst \
$(PACKAGES_DIR)/*.tex \
)
# Recognise pdf viewer automagically
PDF_VIEWER      ?= $(or \
$(shell $(WHICH) zathura 2> /dev/null),\
$(shell $(WHICH) mupdf 2> /dev/null),\
$(shell $(WHICH) mupdf-x11 2> /dev/null),\
$(shell $(WHICH) evince 2> /dev/null),\
$(shell $(WHICH) okular 2> /dev/null),\
$(shell $(WHICH) xdg-open 2> /dev/null),\
$(shell $(WHICH) open 2> /dev/null),\
)

.DEFAULT_GOAL   := all


ifneq ($(strip $(QUIET)),0)
	FD_OUTPUT = 2>&1 > /dev/null
else
	FD_OUTPUT =
endif

ifneq ($(strip $(MAIN_SRC)),) # Do this only if MAIN_SRC is defined

BUILD_DOCUMENT       = $(patsubst %.tex,%.$(FMT),$(MAIN_SRC))
TOC_FILE             = $(patsubst %.tex,$(BUILD_DIR)/%.toc,$(MAIN_SRC))
BIBITEM_FILE         = $(patsubst %.tex,$(BUILD_DIR)/%.bbl,$(MAIN_SRC))
AUX_FILE             = $(patsubst %.tex,$(BUILD_DIR)/%.aux,$(MAIN_SRC))
PYTHONTEX_FILE       = $(patsubst %.tex,$(BUILD_DIR)/%.pytxcode,$(MAIN_SRC))
PDFPC_FILE           = $(shell $(READLINK) -f $(patsubst %.tex,%.pdfpc,$(MAIN_SRC)))
PACKAGES_FILES_BUILD = $(patsubst $(PACKAGES_DIR)/%,$(BUILD_DIR)/%,$(PACKAGES_FILES))
FIGS_SUFFIXES        = %.pdf %.eps %.png %.jpg %.jpeg %.gif %.dvi %.bmp %.svg %.ps
PURGE_SUFFIXES       = %.aux %.bbl %.blg %.fdb_latexmk %.fls %.log %.out \
                       %.ilg %.toc %.nav %.snm

# These files  are to keep  track of the  dependencies for latex  or pdf
# includes, table of contents generation or figure recognition
#
TOC_DEP        = $(strip $(DEPS_DIR))/toc.d
INCLUDES_DEP   = $(strip $(DEPS_DIR))/includes.d
FIGS_DEP       = $(strip $(DEPS_DIR))/figs.d

-include $(INCLUDES_DEP)
-include $(FIGS_DEP)

endif #MAIN_SRC exists



# Main dependencies for BUILD_DOCUMENT
######################################

DEPENDENCIES += \
$(MAIN_SRC) \
$(INCLUDES) \
$(PACKAGES_FILES_BUILD) \
$(FIGURES) \
$(if $(call hasToc,$(MAIN_SRC)),$(TOC_FILE),) \
$(if $(wildcard $(BIBTEX_FILE)),$(BIBITEM_FILE)) \
$(if $(WITH_PYTHONTEX),$(PYTHONTEX_FILE)) \

CLEAN_FILES += \
$(wildcard $(PACKAGES_FILES_BUILD)) \
$(wildcard $(PYTHONTEX_FILE)) \
$(wildcard $(BUILD_DOCUMENT)) \
$(wildcard $(subst %,*,$(PURGE_SUFFIXES))) \
$(wildcard $(DEPS_DIR)) \
$(wildcard $(PDFPC_FILE)) \
$(wildcard $(DIST_DIR)) \
$(wildcard $(DIFF_BUILD_DIR_MAIN)) \
$(wildcard $(DIFF_SRC_NAME)) \





.PHONY: view-pdf open-pdf $(PDF_VIEWER) todo help test force purge dist releases

pdf: FMT=pdf ## Create pdf file
pdf: all
html: FMT=html ## Create html file
revealjs: FMT=html  ## Create a revealjs presentation
man: FMT=1 ## Create man file

all: $(BUILD_DOCUMENT) $(if $(VIEW_PDF),view-pdf) ## (Default) Create BUILD_DOCUMENT


$(BUILD_DOCUMENT): $(DEPENDENCIES)


$(BUILD_DIR)/%: $(PACKAGES_DIR)/%
	$(DEBUG)mkdir -p $(BUILD_DIR)
	-cp $^ $@

# =================
# Force compilation
# =================
#
# This makefile only compiles the TeX document if it is strictly necessary, so
# sometimes to force compilation this target comes in handy.
#
force: ## Force creation of BUILD_DOCUMENT
	-rm $(BUILD_DOCUMENT)
	$(MAKE) $(BUILD_DOCUMENT)

# =======================
# Bibliography generation
# =======================
#
# This generates a `bbl` file from a  `bib` file For documents without a `bib`
# file, this  will also be  targeted, bit  the '-' before  the `$(BIBTEX)`
# ensures that the whole building doesn't fail because of it
#
$(BIBITEM_FILE): $(AUX_FILE) $(BIBTEX_FILE)
	$(ECHO) "Compiling the bibliography"
	-cp $^ $(BUILD_DIR)/
	cd $(BUILD_DIR); $(BIBTEX) $(patsubst %.tex,%,$(MAIN_SRC)) $(FD_OUTPUT)
	$(ECHO) Compiling again $(BUILD_DOCUMENT) to update refs
	$(MAKE) force

#FIXME: find a way of not having to compile the main document again
%.pytxcode: %.tex
	$(ECHO) "Compiling latex for pythontex"
	$(PDFLATEX) $<
	$(ECHO) "Creating pythontex"
	$(PYTHONTEX) $<

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
open-pdf: $(DEPENDENCIES) $(BUILD_DOCUMENT) ## Open pdf build document
	-$(DEBUG)ps aux | $(GREP) -v $(GREP) \
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
	-$(DEBUG)ps aux \
	| $(GREP) -v $(GREP) \
	| $(GREP) "$(PDF_VIEWER)" \
	| $(GREP) "$(BUILD_DOCUMENT)" \
	| $(AWK) '{print $$2}'\
	| { read pid; test -z "$$pid" || kill -s HUP $$pid; }

$(FIGS_SUFFIXES): %.asy
	$(ECHO) Compiling $<
	$(DEBUG)cd $(dir $<) && $(ASYMPTOTE) -f \
		$(shell echo $(suffix $@) | $(TR) -d "\.") $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.gnuplot
	$(ECHO) Compiling $<
	$(DEBUG)cd $(dir $< ) && $(GNUPLOT) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.sh
	$(ECHO) Compiling $<
	$(DEBUG)cd $(dir $< ) && $(SH) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.py
	$(ECHO) Compiling $<
	$(DEBUG)cd $(dir $< ) && $(PY) $(notdir $< ) $(FD_OUTPUT)

$(AUX_FILE): $(PACKAGES_FILES_BUILD)
$(FIGS_SUFFIXES) $(BUILD_DIR)/%.aux: %.tex
	$(ECHO) Compiling $*
	$(DEBUG)mkdir -p $(dir $<)/$(BUILD_DIR)
	$(DEBUG)cd $(dir $<) && $(PDFLATEX) \
		-output-directory $(BUILD_DIR) $(notdir $*.tex ) $(FD_OUTPUT)
ifneq ($(strip $(BUILD_DIR)),.)
	-test ! "$@ = *.aux" || cp \
		$(PWD)/$(dir $<)/$(BUILD_DIR)/$(notdir $@) $(PWD)/$(dir $<)/$(notdir $@)
endif

$(TOC_FILE): $(TOC_DEP)
	$(ECHO) Creating $(TOC_FILE)
	$(DEBUG)mkdir -p $(BUILD_DIR)
	$(DEBUG)cd $(dir $(MAIN_SRC) ) && $(PDFLATEX) \
		-output-directory $(BUILD_DIR) $(notdir $(MAIN_SRC) ) $(FD_OUTPUT)

$(TOC_DEP): $(MAIN_SRC) $(INCLUDES_DEP)
	$(ECHO) Parsing the toc entries
	$(DEBUG)mkdir -p $(dir $@)
	$(DEBUG)$(GREP) -E '\\(section|subsection|subsubsection|chapter|part|subsubsubsection).' \
	$(MAIN_SRC) $(INCLUDES)  \
	| $(SED) 's/.*{\(.*\)}.*/\1/' > $@.control
	$(DEBUG)if ! diff $@ $@.control 2>&1 > /dev/null ; then mv $@.control $@; fi

$(INCLUDES_DEP): $(MAIN_SRC)
	$(ECHO) Parsing the includes dependencies
	$(DEBUG)mkdir -p $(dir $@)
	$(DEBUG)echo INCLUDES = \\ > $@
#@ Include statements should not have a .tex extension
#@ so we are forced to add it
	$(DEBUG)$(GREP) -E '\\(include|input)[^gp]' $<  \
	| $(SED) 's/.*{\(.*\)}.*/\1.tex \\/' >> $@

$(FIGS_DEP): $(MAIN_SRC) $(INCLUDES_DEP)
	$(ECHO) Parsing the graphics dependencies
	$(DEBUG)mkdir -p $(dir $@)
	$(DEBUG)echo FIGURES = \\ > $@
	$(DEBUG)$(GREP) -E '\\include(graphic|pdf).' $(MAIN_SRC) $(INCLUDES)  \
	| $(SED) 's/.*{\(.*\)}.*/\1 \\/' >> $@

# =============
# Main cleaning
# =============
#
# This does a main cleaning of the produced auxiliary files.  Before using it
# check which files are going to be cleaned up.
#
clean: ## Remove build and temporary files
	$(ECHO) Cleaning up...
	-$(DEBUG)rm -rf $(CLEAN_FILES)
ifneq ($(strip $(BUILD_DIR)),.)
	-$(DEBUG)rm -r $(BUILD_DIR)
endif

#PANDOC CONVERSIONS
###################

# FIXME: It doesn't work out of the box
#
# ======================
# Reveal.js presentation
# ======================
#
# This creates a revealjs presentation using the the pandoc program stored in
# the make variable PANDOC.
#
REVEALJS_SRC ?= https://github.com/hakimel/reveal.js/
revealjs: $(MAIN_SRC)
	$(ECHO) Creating revealjs presentation...
	$(ECHO) Gettin revealjs from $(REVEALJS_SRC)
	$(GIT) clone --depth=1 $(REVEALJS_SRC) && rm -rf reveal.js/.git
	$(PANDOC) --mathjax -s -f latex -t revealjs $(MAIN_SRC) -o $(BUILD_DOCUMENT)

# =================
# Unix man document
# =================
#
# This creates a man page using `pandoc`.
#
man: $(MAIN_SRC)
	$(ECHO) Creating man pages...
	$(PANDOC) -s -f latex -t man $(MAIN_SRC) -o $(BUILD_DOCUMENT)

# =============
# HTML document
# =============
#
# This creates an html page using `pandoc`.
#
html: $(MAIN_SRC)
	$(ECHO) Compiling html document...
	$(PANDOC) --mathjax -s -f latex -t html5 $(MAIN_SRC) -o $(BUILD_DOCUMENT)

todo: $(INCLUDES_DEP) ## Print the todos from the main document
	$(ECHO) Parsing \\TODO{} in $(MAIN_SRC)
	$(DEBUG)$(SED) -n "/\\TODO{/,/}/\
	{\
		s/.TODO/===/; \
		s/[{]//g; \
		s/[}]/===/g; \
		p\
	}" $(MAIN_SRC) $(INCLUDES)

# ===========================
# Presenter console generator
# ===========================
#
# `pdfpc` is a nice program for presenting beamer presentations with notes
# and a speaker clock. This target implements a simple script to convert
# the standard `\notes{ }` beamer  command into `pdfpc` compatible files, so
# that you can also see your beamer notes inside the `pdfpc` program.
#
pdf-presenter-console: $(PDFPC_FILE) ## Create annotations file for the pdfpc program
$(PDFPC_FILE): $(MAIN_SRC)
	echo "[file]" > $@
	echo "$(PDF_DOCUMENT)" >> $@
	echo "[notes]" >> $@
	cat $(MAIN_SRC) | $(AWK) '\
		BEGIN { frame = 0; initialized = 0; } \
		/(\\begin{frame}|\\frame{)/ { \
			if(!/[%]/) { \
				frame++; print "###",frame \
			} \
		} \
		/\\note{/,/^\s*}\s*$$/ { \
			if(!/\\note{/ && !/^[ ]*}[ ]*$$/) {\
				if (frame == 0 && initialized == 0){ \
					frame++; \
					print "###",frame; \
					initialized = 1; \
				} \
				print $$0 ; \
			}\
		} \
		END { print frame } \
	' | tee -a $@

RELEASES_DIR=releases
RELEASES_FMT=tar
releases: $(BUILD_DOCUMENT) ## Create all releases (according to tags)
	$(ECHO) Copying releases to $(RELEASES_DIR) folder in $(RELEASES_FMT) format
	$(DEBUG)mkdir -p $(RELEASES_DIR)
	$(DEBUG)for tag in $$($(GIT) tag); do\
		echo "Processing $$tag"; \
		$(GIT) archive --format=$(RELEASES_FMT) \
		--prefix=$$tag/ $$tag > $(RELEASES_DIR)/$$tag.$(RELEASES_FMT); \
	done

# ============
# Distribution
# ============
#
# Create a distribution folder wit the bare minimum to compile your project.
# For example it will consider the files in the DEPENDENCIES variable, so make
# sure to update or add DEPENDENCIES to it in the config.mk per user
# configuration.
#
dist: $(BUILD_DOCUMENT) ## Create a dist folder with the bare minimum to compile
	$(ECHO) "Creating dist folder"
	$(DEBUG)mkdir -p $(DIST_DIR)
	$(ECHO) "Copying the Makefile"
	$(DEBUG)cp Makefile $(DIST_DIR)/
	$(ECHO) "Copying the target document"
	$(DEBUG)cp $(BUILD_DOCUMENT) $(DIST_DIR)/
	$(DEBUG)test -n "$(BIBTEX_FILE)" && {\
		$(ECHO) "Copying .bib files"; \
		cp $(BIBTEX_FILE) $(DIST_DIR)/; \
		} || echo "No bibfiles"
	$(ECHO) "Creating folder for dependencies"
	$(DEBUG)echo $(DEPENDENCIES)\
	 | $(XARGS) -n1 dirname\
	 | $(XARGS) -n1 -I FF mkdir -p $(DIST_DIR)/FF
	$(ECHO) "Copying dependencies"
	$(DEBUG)echo $(DEPENDENCIES)\
	 | $(TR) " " "\n" \
	 | $(XARGS) -n1 -I FF cp FF $(DIST_DIR)/FF
	$(ECHO) "Creating folder for latex libraries"
	$(DEBUG)echo $(PACKAGES_FILES)\
	 | $(XARGS) -n1 dirname\
	 | $(XARGS) -n1 -I FF mkdir -p $(DIST_DIR)/FF
	$(ECHO) "Copying latex libraries"
	$(DEBUG)echo $(PACKAGES_FILES)\
	 | $(TR) " " "\n" \
	 | $(XARGS) -n1 -I FF cp FF $(DIST_DIR)/FF

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
	$(ECHO) Creating diff between $(NEW_COMMIT) and $(OLD_COMMIT)
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


# ============
# Check syntax
# ============
#
# It checks the syntax (lints) of all the tex sources using the program in the
# TEX_LINTER variable.
#
lint: $(INCLUDES_DEP) ## Check syntax of latex sources (TEX_LINTER)
	$(TEX_LINTER) $(MAIN_SRC) $(INCLUDES)

watch: ## Build if changes
	(echo $(MAIN_SRC) | entr make )&
unwatch: ## Cancel Watching
	killall entr

# ===============================
# Update the makefile from source
# ===============================
#
# You can always get the  last `latex-makefile` version using this target.
# You may override the `GH_REPO_FILE` to  any path where you save your own
# personal makefile
#
GH_REPO_FILE ?= https://raw.githubusercontent.com/alejandrogallo/latex-makefile/master/dist/Makefile
update: ## Update the makefile from the repository
	$(ECHO) "Getting makefile from $(GH_REPO_FILE)"
	$(DEBUG)wget $(GH_REPO_FILE) -O Makefile

# ====================================
# Ctags generation for latex documents
# ====================================
#
# Generate a tags  file so that you can navigate  through the tags using
# compatible editors such as emacs or (n)vi(m).
#
tags: $(MAIN_SRC) $(INCLUDES_DEP) ## Create TeX exhuberant ctags
	$(CTAGS) --language-force=tex -R *

purge: clean ## Remove recursively with suffixes in PURGE_SUFFIXES
	$(ECHO) Purging files across directories... be careful
	$(DEBUG)echo "$(PURGE_SUFFIXES)" \
	| $(TR) "%" "*" \
	| $(XARGS) -n1  $(FIND) . -name \
	| while read i; do echo $$i ; rm $$i; done

# This is used for printing defined variables from Some other scripts. For
# instance if you want to know the value of the PDF_VIEWER defined in the
# Makefile, then you would do
#    make print-PDF_VIEWER
# and this would output PDF_VIEWER=mupdf for instance.
FORCE:
print-%:
	$(DEBUG)echo '$*=$($*)'

# ================
# Print quick help
# ================
#
# It prints a quick help in the terminal
help: ## Prints help for targets with comments
	$(DEBUG)$(or $(AWK),awk) ' \
		BEGIN {FS = ":.*?## "}; \
		/^## *<<HELP/,/^## *HELP/ { \
			help=$$1; \
			gsub("#","",help); \
			if (! match(help, "HELP")) \
				print help ; \
		}; \
		/^[a-zA-Z0-9_\-.]+:.*?## .*$$/{ \
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 ; \
		};' \
		$(MAKEFILE_LIST)

FORCE:
help-%:
	$(DEBUG)sed -n "/[#] [=]\+/,/^$*: / { /"$*":/{q}; p; } " $(MAKEFILE_LIST) \
		| tac \
		| sed -n "1,/===/ {/===/n; s/^# //p}" \
		| tac \
		| sed -n "p; 1s/./=/gp; 1a\ "


## <<HELP
#
# v1.3.4
# https://github.com/alejandrogallo/latex-makefile
# Copyright © 2017 Alejandro Gallo GPLv3
#
## HELP

# vim: nospell fdm=marker cc=90
