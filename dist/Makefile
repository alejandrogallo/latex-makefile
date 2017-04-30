
MAKEFILE_VERSION = v1.5.7-44-gf3fa801
MAKEFILE_DATE = 30-04-2017 17:02

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

# File: os.m4
# Recognise OS
ifeq ($(shell uname),Linux)
LINUX := 1
OSX   :=
else
LINUX :=
OSX   := 1
endif




# File: shell-utils.m4

# Shell used
SH         ?= bash
# Alias for `SHELL'
SHELL      ?= $(SH)
# Python interpreter
PY         ?= python
# Alias for `PY'
PYTHON     ?= $(PY)
# Grep program version
GREP       ?= grep
# Find utility
FIND       ?= find
# `sed` program version
SED        ?= $(if $(OSX),gsed,sed)
# `awk` program to use
AWK        ?= $(if $(OSX),gawk,awk)
# For creating tags
CTAGS      ?= ctags
# To get complete paths
READLINK   ?= $(if $(OSX),greadlink,readlink)
# `xargs` program to use
XARGS      ?= xargs
# `tr` program to use
TR         ?= tr
# `git` version to use
GIT        ?= git
# `which` program to use
WHICH      ?= which
# `sort` program to use
SORT       ?= sort
# `uniq` program to use
UNIQ       ?= uniq



# File: latex.m4
# File: log.m4

# If secondary programs output is shown
QUIET ?= 0
# If the log messages should be also muted
QQUIET     ?=
# If the commands issued should be printed write `DEBUG=1` if you want to see
# all commands.
DEBUG      ?=
# For coloring
TPUT       ?= $(shell $(WHICH) tput 2> /dev/null)
# If messages should have color
WITH_COLOR ?= 1

ifneq ($(strip $(QUIET)),0)
	FD_OUTPUT = 2>&1 > /dev/null
else
	FD_OUTPUT =
endif

ifdef DEBUG
	DBG_FLAG =
else
	DBG_FLAG = @
endif

# Print commands like [CMD]
define print-cmd-name
"[$(COLOR_LB) \
$(shell \
	if test "$(1)" = g++; then \
		echo -n GXX; \
	elif test "$(1)" = gcc; then \
		echo -n GCC; \
	elif test "$(1)" = icc; then \
		echo -n ICC; \
	elif test "$(1)" = cc; then \
		echo -n CC; \
	elif test "$(1)" = povray; then \
		echo -n POV; \
	elif test "$(1)" = perl; then \
		echo -n PL; \
	elif test "$(1)" = ruby; then \
		echo -n RB; \
	elif test "$(1)" = ruby2; then \
		echo -n RB2; \
	elif test "$(1)" = python2; then \
		echo -n PY2; \
	elif test "$(1)" = python3; then \
		echo -n PY3; \
	elif test "$(1)" = pdflatex; then \
		echo -n pdfTeX; \
	elif test "$(1)" = bash; then \
		echo -n BSH; \
	elif test "$(1)" = gnuplot; then \
		echo -n GPT; \
	elif test "$(1)" = mupdf; then \
		echo -n muPDF; \
	else \
		echo -n "$(1)" | tr a-z A-Z ; \
	fi
)\
$(COLOR_E)]"
endef

ifndef QQUIET

ifeq ($(strip $(WITH_COLOR)),1)
# Red
COLOR_R         ?= $(if $(TPUT),$(shell $(TPUT) setaf 1),"\033[0;31m")
# Green
COLOR_G         ?= $(if $(TPUT),$(shell $(TPUT) setaf 2),"\033[0;32m")
# Yellow
COLOR_Y         ?= $(if $(TPUT),$(shell $(TPUT) setaf 3),"\033[0;33m")
# Dark blue
COLOR_DB        ?= $(if $(TPUT),$(shell $(TPUT) setaf 4),"\033[0;34m")
# Lila
COLOR_L         ?= $(if $(TPUT),$(shell $(TPUT) setaf 5),"\033[0;35m")
# Light blue
COLOR_LB        ?= $(if $(TPUT),$(shell $(TPUT) setaf 6),"\033[0;36m")
# Empty color
COLOR_E         ?= $(if $(TPUT),$(shell $(TPUT) sgr0),"\033[0m")
ARROW           ?= @echo "$(COLOR_L)===>$(COLOR_E)"
else
ARROW           ?= @echo "===>"
endif #WITH_COLOR

ECHO            ?= @echo

else
ARROW           := @ > /dev/null echo
ECHO            := @ > /dev/null echo
endif #QQUIET



# Function to try to discover automatically the main latex document
define discoverMain
$(shell \
	$(GREP) -H '\\begin{document}' *.tex 2>/dev/null \
	| $(removeTexComments) \
	| head -1 \
	| $(AWK) -F ":" '{print $$1}' \
)
endef

# Remove comments from some file, this variables is intended to be put
# in a shell call for processing of TeX files
removeTexComments=$(SED) "s/[^\\]%.*//g; s/^%.*//g"

define recursiveDiscoverIncludes
$(shell \
	files=$(1);\
	for i in $$(seq 1 $(2)); do \
		files="$$(\
			$(SED) -n '/\in\(clude\|put\)\s*[{]/p' $$files 2>/dev/null \
					| $(removeTexComments) \
					| $(SED) 's/\.tex//g' \
					| $(SED) 's/.*{\(.*\)}.*/\1.tex /' \
		)"; \
		test -n "$$files" || break; \
		echo $$files; \
	done \
)
endef

define hasToc
$(shell\
	$(GREP) '\\tableofcontents' $(1) \
	| $(removeTexComments) \
	| $(SED) "s/ //g" \
)
endef




# Folder to build the project
BUILD_DIR ?= .
# Shell utilities
LATEX ?= pdflatex
# For creating differences
LATEXDIFF ?= latexdiff
# Main pdflatex engine
PDFLATEX ?= pdflatex




# Main texfile in the current directory
MAIN_SRC ?= $(call discoverMain)
# Format to build to
FMT ?= pdf
# If `BUILD_DOCUMENT` should be previewed after building
VIEW ?= 1
# Depth for discovering automatically included texfiles
INCLUDES_REC ?= 3
# Texfiles included in the main tex file
INCLUDES ?= $(call recursiveDiscoverIncludes,$(MAIN_SRC),$(INCLUDES_REC))
# All `texfiles` in the project
TEXFILES ?= $(MAIN_SRC) $(INCLUDES)
# Bibtex files in the current directory
BIBTEX_FILES ?= $(call discoverBibtexFiles,$(TEXFILES))
# Source directory
PREFIX ?= $(PWD)

.DEFAULT_GOAL := all



ifneq ($(strip $(MAIN_SRC)),) # Do this only if MAIN_SRC is defined

BUILD_DOCUMENT       = $(patsubst %.tex,%.$(FMT),$(MAIN_SRC))
TOC_FILE             = $(patsubst %.tex,$(BUILD_DIR)/%.toc,$(MAIN_SRC))
BIBITEM_FILES        = $(patsubst %.tex,$(BUILD_DIR)/%.bbl,$(MAIN_SRC))
AUX_FILE             = $(patsubst %.tex,$(BUILD_DIR)/%.aux,$(MAIN_SRC))
PYTHONTEX_FILE       = $(patsubst %.tex,$(BUILD_DIR)/%.pytxcode,$(MAIN_SRC))
PDFPC_FILE           = $(patsubst %.tex,%.pdfpc,$(MAIN_SRC))
PACKAGES_FILES_BUILD = $(patsubst $(PACKAGES_DIR)/%,$(BUILD_DIR)/%,$(PACKAGES_FILES))

endif #MAIN_SRC exists

FIGS_SUFFIXES        = %.pdf %.eps %.png %.jpg %.jpeg %.gif %.dvi %.bmp %.svg \
                       %.ps
PURGE_SUFFIXES       = %.aux %.bbl %.blg %.fdb_latexmk %.fls %.log %.out \
                       %.ilg %.toc %.nav %.snm
SUPPORTED_SUFFIXES   = %.pdf %.div %.ps %.eps %.1 %.html

# File: deps.m4


# These files  are to keep  track of the  dependencies for latex  or pdf
# includes, table of contents generation or figure recognition
#
TOC_DEP ?= $(strip $(DEPS_DIR))/toc.d
FIGS_DEP ?= $(strip $(DEPS_DIR))/figs.d

# Folder to keep makefile dependencies
DEPS_DIR ?= .deps

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),help)
-include $(FIGS_DEP)
endif
endif

# Figures included in all texfiles
FIGURES ?=

$(TOC_FILE): $(TOC_DEP)
	$(ECHO) $(call print-cmd-name,$(PDFLATEX)) $@
	$(DBG_FLAG)mkdir -p $(BUILD_DIR)
	$(DBG_FLAG)cd $(dir $(MAIN_SRC) ) && $(PDFLATEX) \
		$(BUILD_DIR_FLAG) $(notdir $(MAIN_SRC) ) $(FD_OUTPUT)

$(TOC_DEP): $(TEXFILES)
	$(ARROW) Writing table of contents into $(TOC_DEP)
	$(DBG_FLAG)mkdir -p $(dir $@)
	$(DBG_FLAG)$(GREP) -E \
		'\\(section|subsection|subsubsection|chapter|part|subsubsubsection).' \
		$(TEXFILES)  \
		| $(removeTexComments) \
		| $(SED) 's/.*{\(.*\)}.*/\1/' > $@.control
	$(DBG_FLAG)test -f "$@" && \
		{ test diff $@ $@.control 2>&1 > /dev/null && mv $@.control $@; } || \
		mv $@.control $@

$(FIGS_DEP): $(TEXFILES)
	$(ARROW) Writing graphics dependencies into $(FIGS_DEP)
	$(DBG_FLAG)mkdir -p $(dir $@)
	$(DBG_FLAG)echo FIGURES = \\ > $@
	$(DBG_FLAG)$(GREP) --no-filename -E '\\include(graphic|pdf).' $(TEXFILES)  \
	| $(removeTexComments) \
	| $(SED) -n 's/.*{\([^{}]\+\)}.*/\1 \\/p' >> $@

figs: $(FIGURES) ## Make figures
deps: $(FIGS_DEP) ## Parse dependencies for the main texfile




# File: bibliography.m4


define discoverBibtexFiles
$(shell \
	$(GREP) -E '\\bibliography\s*{' $(1) 2> /dev/null  \
		| $(removeTexComments) \
		| $(SED) 's/.*\\bibliography//' \
		| $(SED) 's/\.bib//g' \
		| $(TR) "," "\n" \
		| $(TR) -d "{}" \
		| $(SED) 's/\s*$$/.bib /' \
		| $(SORT) \
		| $(UNIQ) \
)
endef

# For converting document formats
BIBTEX ?= bibtex

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
	-$(DBG_FLAG)test $(BUILD_DIR) = . || { \
		for bibfile in $(BIBTEX_FILES); do \
			mkdir -p $(BUILD_DIR)/$$(dirname $$bibfile); \
			cp -u $$bibfile $(BUILD_DIR)/$$(dirname $$bibfile); \
		done \
		}
	$(ECHO) $(call print-cmd-name,$(BIBTEX)) $@
	$(DBG_FLAG)cd $(BUILD_DIR); $(BIBTEX) $(patsubst %.tex,%,$(MAIN_SRC)) $(FD_OUTPUT)
	$(ARROW) Compiling again $(BUILD_DOCUMENT) to update refs
	$(DBG_FLAG)$(MAKE) --no-print-directory force





# General dependencies for `BUILD_DOCUMENT`
DEPENDENCIES ?= \
$(BUILD_DIR) \
$(MAIN_SRC) \
$(INCLUDES) \
$(PACKAGES_FILES_BUILD) \
$(FIGURES) \
$(if $(call hasToc,$(MAIN_SRC)),$(TOC_FILE),$(AUX_FILE)) \
$(if $(wildcard $(BIBTEX_FILES)),$(BIBITEM_FILES)) \
$(if $(WITH_PYTHONTEX),$(PYTHONTEX_FILE)) \
$(if $(CHECK_SPELL),spelling) \

.PHONY: view-pdf open-pdf $(PDF_VIEWER) todo help test force dist releases

pdf: FMT=pdf ## Create pdf file
html: FMT=html ## Create html file
revealjs: FMT=html  ## Create a revealjs presentation
man: FMT=1 ## Create man file
$(FMT): $(BUILD_DOCUMENT)

all: $(FMT) $(if $(VIEW),view-$(FMT)) ## (Default) Create BUILD_DOCUMENT

$(BUILD_DOCUMENT): $(DEPENDENCIES)

# =================
# Force compilation
# =================
#
# This makefile only compiles the TeX document if it is strictly necessary, so
# sometimes to force compilation this target comes in handy.
#
force: ## Force creation of BUILD_DOCUMENT
	$(DBG_FLAG)$(MAKE) --no-print-directory -W $(MAIN_SRC) $(BUILD_DOCUMENT)

# File: build-dir.m4


# Folder to build the project
BUILD_DIR ?= .

# Build dir flag for latex.
# If `BUILD_DIR = .` then `BUILD_DIR_FLAG` is not defined,
# else `BUILD_DIR = -output-directory $(BUILD_DIR)`
BUILD_DIR_FLAG  ?= $(if \
                   $(filter-out \
                   .,$(strip $(BUILD_DIR))),-output-directory $(BUILD_DIR))

$(BUILD_DIR):
	$(ARROW) Creating the $@ directory
	$(DBG_FLAG)mkdir -p $@ $(FD_OUTPUT)






# File: libraries.m4


# Tex libraries directory
PACKAGES_DIR    ?= libtex

# Which files are tex libraries
PACKAGES_FILES  ?= $(wildcard \
$(PACKAGES_DIR)/*.sty \
$(PACKAGES_DIR)/*.rtx \
$(PACKAGES_DIR)/*.cls \
$(PACKAGES_DIR)/*.bst \
$(PACKAGES_DIR)/*.tex \
$(PACKAGES_DIR)/*.clo \
)

$(BUILD_DIR)/%: $(PACKAGES_DIR)/%
	$(ARROW) Copying TeX libraries: $@
	$(DBG_FLAG)mkdir -p $(BUILD_DIR)
	$(DBG_FLAG)cp $^ $@




# File: html.m4


BROWSER ?= firefox
view-html: $(BUILD_DOCUMENT)
	$(DBG_FLAG)($(BROWSER) $(BUILD_DOCUMENT) &)&





# File: pythontex.m4


# If pythontex is being used
WITH_PYTHONTEX  ?=

PYTHONTEX  ?= pythontex

#FIXME: find a way of not having to compile the main document again
%.pytxcode: %.tex
	$(ARROW) "Compiling latex for pythontex"
	$(PDFLATEX) $<
	$(ARROW) "Creating pythontex"
	$(PYTHONTEX) $<





# File: figure-targets.m4


# Eps to pdf converter
EPS2PDF ?= epstopdf
# For asymptote figures
ASYMPTOTE ?= asy
# Gnuplot interpreter
GNUPLOT ?= gnuplot

$(FIGS_SUFFIXES): %.asy
	$(ECHO) $(call print-cmd-name,$(ASYMPTOTE)) $@
	$(DBG_FLAG)cd $(dir $<) && $(ASYMPTOTE) -f \
		$(shell echo $(suffix $@) | $(TR) -d "\.") $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.gnuplot
	$(ECHO) $(call print-cmd-name,$(GNUPLOT)) $@
	$(DBG_FLAG)cd $(dir $< ) && $(GNUPLOT) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.sh
	$(ECHO) $(call print-cmd-name,$(SH)) $@
	$(DBG_FLAG)cd $(dir $< ) && $(SH) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.py
	$(ECHO) $(call print-cmd-name,$(PY)) $@
	$(DBG_FLAG)cd $(dir $< ) && $(PY) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.tex
	$(ECHO) $(call print-cmd-name,$(PDFLATEX)) $@
	$(DBG_FLAG)mkdir -p $(dir $<)/$(BUILD_DIR)
	$(DBG_FLAG)cd $(dir $<) && $(PDFLATEX) \
		$(BUILD_DIR_FLAG) $(notdir $*.tex ) $(FD_OUTPUT)
ifneq ($(strip $(BUILD_DIR)),.)
	-$(DBG_FLAG)test ! "$@ = *.aux" || cp \
		$(PWD)/$(dir $<)/$(BUILD_DIR)/$(notdir $@) $(PWD)/$(dir $<)/$(notdir $@)
endif

%.pdf: %.eps
	$(ECHO) $(call print-cmd-name,$(EPS2PDF)) $@
	$(DBG_FLAG)cd $(dir $< ) && $(EPS2PDF) $(notdir $< ) $(FD_OUTPUT)





# File: document-targets.m4


%.tex: %.sh
	$(ARROW) Creating $@ from $<
	$(DBG_FLAG)cd $(dir $<) && $(SH) $(notdir $<) $(FD_OUTPUT)

%.tex: %.py
	$(ARROW) Creating $@ from $<
	$(DBG_FLAG)cd $(dir $<) && $(PY) $(notdir $<) $(FD_OUTPUT)

$(AUX_FILE):
	$(ARROW) Creating $@
	$(DBG_FLAG)$(PDFLATEX) $(BUILD_DIR_FLAG) $(MAIN_SRC) $(FD_OUTPUT)





# File: pdf-viewer.m4


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








# File: clean.m4


# Remove command
RM ?= rm
RM_FLAGS ?= -rf

# Default clean file to be cleaned
DEFAULT_CLEAN_FILES = \
$(wildcard $(PACKAGES_FILES_BUILD)) \
$(wildcard $(PYTHONTEX_FILE)) \
$(wildcard $(BUILD_DOCUMENT)) \
$(wildcard $(subst %,*,$(PURGE_SUFFIXES))) \
$(wildcard $(subst %,$(patsubst %.tex,%,$(MAIN_SRC)),$(SUPPORTED_SUFFIXES))) \
$(wildcard $(DEPS_DIR)) \
$(wildcard $(PDFPC_FILE)) \
$(wildcard $(DIST_DIR)) \
$(wildcard $(DIFF_BUILD_DIR_MAIN)) \
$(wildcard $(DIFF_SRC_NAME)) \
$(if $(filter-out .,$(strip $(BUILD_DIR))),$(wildcard $(BUILD_DIR))) \

# Files to be cleaned
CLEAN_FILES ?= $(DEFAULT_CLEAN_FILES)

# =============
# Main cleaning
# =============
#
# This does a main cleaning of the produced auxiliary files.  Before using it
# check which files are going to be cleaned up.
#
clean: ## Remove build and temporary files
	$(ARROW) Cleaning up...
	$(DBG_FLAG) {\
		for file in $(CLEAN_FILES); do \
			test -e $$file && { \
				$(RM) $(RM_FLAGS) $$file &&      \
				echo $(call print-cmd-name,RM) "$$file";\
		 } || : ; \
		done \
	}





# File: todo.m4


todo: $(TEXFILES) ## Print the todos from the main document
	$(ARROW) Parsing \\TODO{} in $(MAIN_SRC)
	$(DBG_FLAG)$(SED) -n "/\\TODO{/,/}/\
	{\
		s/.TODO/===/; \
		s/[{]//g; \
		s/[}]/===/g; \
		p\
	}" $(TEXFILES)





# File: pandoc.m4


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





# File: pdfpc.m4


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
$(PDFPC_FILE): $(TEXFILES)
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





# File: release.m4


RELEASES_DIR=releases
RELEASES_FMT=tar
releases: $(BUILD_DOCUMENT) ## Create all releases (according to tags)
	$(ARROW) Copying releases to $(RELEASES_DIR) folder in $(RELEASES_FMT) format
	$(DBG_FLAG)mkdir -p $(RELEASES_DIR)
	$(DBG_FLAG)for tag in $$($(GIT) tag); do\
		echo "Processing $$tag"; \
		$(GIT) archive --format=$(RELEASES_FMT) \
		--prefix=$$tag/ $$tag > $(RELEASES_DIR)/$$tag.$(RELEASES_FMT); \
	done





# File: dist.m4


# Distribution directory
DIST_DIR ?= $(PREFIX)/dist

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
	$(ARROW) "Creating dist folder"
	$(DBG_FLAG)mkdir -p $(DIST_DIR)
	$(ARROW) "Copying the Makefile"
	$(DBG_FLAG)cp Makefile $(DIST_DIR)/
	$(ARROW) "Copying the target document"
	$(DBG_FLAG)cp $(BUILD_DOCUMENT) $(DIST_DIR)/
	$(ARROW) "Copying .bib files"
	$(DBG_FLAG)test -n "$(BIBTEX_FILES)" && {\
		for bibfile in $(BIBTEX_FILES); do \
			mkdir -p $(DIST_DIR)/$$(dirname $$bibfile); \
			cp -u $$bibfile $(DIST_DIR)/$$(dirname $$bibfile); \
		done \
		} || echo "No bibfiles"
	$(ARROW) "Creating folder for dependencies"
	$(DBG_FLAG)echo $(DEPENDENCIES)\
		| $(XARGS) -n1 dirname\
		| $(XARGS) -n1 -I FF mkdir -p $(DIST_DIR)/FF
	$(ARROW) "Copying dependencies"
	$(DBG_FLAG)echo $(DEPENDENCIES)\
		| $(TR) " " "\n" \
		| $(XARGS) -n1 -I FF cp -r FF $(DIST_DIR)/FF
ifneq ($(strip $(PACKAGES_FILES)),)
	$(ARROW) "Creating folder for latex libraries"
	$(DBG_FLAG)test -n "$(PACKAGES_FILES)" && echo $(PACKAGES_FILES)\
		| $(XARGS) -n1 dirname\
		| $(XARGS) -n1 -I FF mkdir -p $(DIST_DIR)/FF
	$(ARROW) "Copying latex libraries"
	$(DBG_FLAG)test -n "$(PACKAGES_FILES)" && echo $(PACKAGES_FILES)\
		| $(TR) " " "\n" \
		| $(XARGS) -n1 -I FF cp FF $(DIST_DIR)/FF
endif

# ==================
# Distribution clean
# ==================
#
# Clean distribution files
#
dist-clean: CLEAN_FILES=$(DIST_DIR) ## Clean distribution files
dist-clean: clean





# File: diff.m4


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
	$(DBG_FLAG)mkdir -p $(DIFF_BUILD_DIR)
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





# File: spelling.m4


SPELLER ?= aspell
SPELL_DIR ?= .spell
SPELL_LANG ?= en
CHECK_SPELL ?=

# ==============
# Check spelling
# ==============
#
# It checks the spelling of all the tex sources using the program in the
# SPELLER variable. The default value of the language is english, you can
# change it by setting in your `config.mk` file
# ```make
# SPELL_LANG = fr
# ```
# if you happen to write in french.
#
spelling: $(TEXFILES) ## Check spelling of latex sources
	$(ARROW) Checking the spelling in $(SPELL_LANG)
	$(DBG_FLAG)mkdir -p $(SPELL_DIR)
	$(DBG_FLAG)for file in $?; do \
		$(SPELLER) --home-dir=$(SPELL_DIR) \
		-l $(SPELL_LANG) -t -c $$file; \
	done





# File: lint.m4


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





# File: watch.m4


watch: ## Build if changes
	$(DBG_FLAG)(echo $(TEXFILES) $(BIBTEX_FILES) | $(TR) " " "\n" | entr make &)&

unwatch: ## Cancel Watching
	killall entr





# File: update.m4


# ===============================
# Update the makefile from source
# ===============================
#
# You can always get the  last `latex-makefile` version using this target.
# You may override the `GH_REPO_FILE` to  any path where you save your own
# personal makefile
#
update: ## Update the makefile from the repository
	$(ARROW) "Getting makefile from $(GH_REPO_FILE)"
	$(DBG_FLAG)wget $(GH_REPO_FILE) -O Makefile
GH_REPO_FILE ?= https://raw.githubusercontent.com/alejandrogallo/latex-makefile/master/dist/Makefile





# File: tags.m4


# ====================================
# Ctags generation for latex documents
# ====================================
#
# Generate a tags  file so that you can navigate  through the tags using
# compatible editors such as emacs or (n)vi(m).
#
tags: $(TEXFILES) ## Create TeX exhuberant ctags
	$(CTAGS) --language-force=tex -R *





# File: print-variable.m4


# This is used for printing defined variables from Some other scripts. For
# instance if you want to know the value of the PDF_VIEWER defined in the
# Makefile, then you would do
#    make print-PDF_VIEWER
# and this would output PDF_VIEWER=mupdf for instance.
FORCE:
print-%:
	$(DBG_FLAG)echo '$*=$($*)'

# =====================================
# Print a variable used by the Makefile
# =====================================
#
# For debugging purposes it is useful to print out some variables that the
# makefile is using, for that just type `make print` and you will be prompted
# to insert the name of the variable that you want to know.
#
FORCE:
print: ## Print a variable
	$(DBG_FLAG)read -p "Variable to print: " variable && \
		$(MAKE) --no-print-directory print-$$variable





# File: help.m4


# ================
# Print quick help
# ================
#
# It prints a quick help in the terminal
help: ## Prints help for targets with comments
	$(DBG_FLAG)$(or $(AWK),awk) ' \
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
	@echo ""
	@echo "  $(MAKEFILE_VERSION)"
	@echo "  https://github.com/alejandrogallo/latex-makefile"
	@echo "  Copyright Alejandro Gallo GPLv3 $(MAKEFILE_DATE)"
	@echo ""





# File: help-target.m4


FORCE:
help-%:
	$(DBG_FLAG)$(SED) -n "/[#] [=]\+/,/^$*: / { /"$*":/{q}; p; } " $(MAKEFILE_LIST) \
		| tac \
		| sed -n "1,/===/ {/===/n; s/^# //p}" \
		| tac \
		| sed -n "p; 1s/./=/gp; 1a\ "





# vim: cc=80

