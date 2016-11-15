#local configuration
-include config.mk

ifeq ($(shell uname),Linux)
LINUX := 1
OSX   :=
else
LINUX :=
OSX   := 1
endif


# PARAMETERS, OVERRIDE THESE
############################

#Shell utilities
SH              ?= bash
PY              ?= python
GREP            ?= grep
SED             ?= $(if $(OSX),gsed,sed)
AWK             ?= $(if $(OSX),gawk,awk)
CTAGS           ?= ctags
READLINK        ?= $(if $(OSX),greadlink,readlink)
XARGS           ?= xargs
TR              ?= tr
GIT             ?= git
WHICH           ?= which
ECHO            ?= @echo -e "\033[0;35m===>\033[0m"

# Function to try to discover automatically
# the main latex document
discoverMain = $(shell \
                   $(GREP) -H '\\begin{document}' *.tex 2>/dev/null \
                   | head -1 \
                   | $(AWK) -F ":" '{print $$1}')

#MAIN_SRC        ?= main.tex
MAIN_SRC        ?= $(call discoverMain) # Discover automatically
BIBTEX_FILE     ?= $(patsubst %.tex,%.bib,$(MAIN_SRC))
DEPS_DIR        ?= deps
PDF_VIEWER      ?= $(or \
$(shell $(WHICH) zathura 2> /dev/null),\
$(shell $(WHICH) mupdf 2> /dev/null),\
$(shell $(WHICH) mupdf-x11 2> /dev/null),\
$(shell $(WHICH) evince 2> /dev/null),\
$(shell $(WHICH) okular 2> /dev/null),\
$(shell $(WHICH) xdg-open 2> /dev/null),\
$(shell $(WHICH) open 2> /dev/null),\
)
LATEX           ?= pdflatex
PDFLATEX        ?= pdflatex
ASYMPTOTE       ?= asy
GNUPLOT         ?= gnuplot
PANDOC          ?= pandoc
BIBTEX          ?= bibtex
DEPENDENCIES    ?=
FIGURES         ?=
# sources included through \include
INCLUDES        ?=
WITH_PYTHONTEX  ?=
# Do you use pythontex?
PYTHONTEX       ?= pythontex
# if 1 run commands quietly
QUIET           ?= 0
PREFIX          ?= $(PWD)
DIST_DIR        ?= $(PREFIX)/dist


.DEFAULT_GOAL   := all


ifneq ($(QUIET),0)
	FD_OUTPUT = 2>&1 > /dev/null
else
	FD_OUTPUT =
endif

# Do this only if MAIN_SRC is defined
ifneq ($(strip $(MAIN_SRC)),)

PDF_DOCUMENT   = $(shell $(READLINK) -f $(patsubst %.tex,%.pdf,$(MAIN_SRC)))
DVI_DOCUMENT   = $(shell $(READLINK) -f $(patsubst %.tex,%.dvi,$(MAIN_SRC)))
MAN_DOCUMENT   = $(patsubst %.tex,%.1,$(MAIN_SRC))
HTML_DOCUMENT  = $(patsubst %.tex,%.html,$(MAIN_SRC))
TOC_FILE       = $(patsubst %.tex,%.toc,$(MAIN_SRC))
BIBITEM_FILE   = $(patsubst %.bib,%.bbl,$(BIBTEX_FILE))
PYTHONTEX_FILE = $(patsubst %.tex,%.pytxcode,$(MAIN_SRC))
PDFPC_FILE     = $(shell $(READLINK) -f $(patsubst %.tex,%.pdfpc,$(MAIN_SRC)))
FIGS_SUFFIXES  = %.pdf %.eps %.png %.jpg %.jpeg %.gif %.dvi %.bmp %.svg %.ps
PURGE_SUFFIXES = %.aux %.bbl %.blg %.fdb_latexmk %.fls %.log %.out %.ilg %.toc
BUILD_DOCUMENT = $(PDF_DOCUMENT)

# These files  are to keep  track of the  dependencies for latex  or pdf
# includes, table of contents generation or figure recognition
#
TOC_DEP        = $(DEPS_DIR)/toc.d
INCLUDES_DEP   = $(DEPS_DIR)/includes.d
FIGS_DEP       = $(DEPS_DIR)/figs.d

include $(INCLUDES_DEP)
include $(FIGS_DEP)

endif #MAIN_SRC exists



# Main dependencies for BUILD_DOCUMENT
######################################

DEPENDENCIES += \
$(MAIN_SRC) \
$(INCLUDES) \
$(FIGURES) \
$(TOC_FILE) \
$(if $(wildcard $(BIBTEX_FILE)),$(BIBITEM_FILE)) \
$(if $(WITH_PYTHONTEX),$(PYTHONTEX_FILE)) \




.PHONY: view-pdf open-pdf $(PDF_VIEWER) todo help test force purge dist releases

all: $(BUILD_DOCUMENT) view-pdf ## (Default) Create BUILD_DOCUMENT


$(BUILD_DOCUMENT): $(DEPENDENCIES)

force: ## Force creation of BUILD_DOCUMENT
	-rm $(BUILD_DOCUMENT)
	$(MAKE) $(BUILD_DOCUMENT)

# =======================
# Bibliography generation
# =======================
#
# This generates a bbl file from a  bib file For documents without a bib
# file, this  will also be  targeted, bit  the '-' before  the $(BIBTEX)
# ensures that the whole building doesn't fail because of it
#
$(BIBITEM_FILE): $(BIBTEX_FILE)
	$(ECHO) "Compiling the bibliography"
	-$(BIBTEX) $(patsubst %.bib,%,$(BIBTEX_FILE)) $(FD_OUTPUT)
	$(ECHO) Compiling again $(BUILD_DOCUMENT) to update refs
	$(MAKE) force

#FIXME: find a way of not having to compile the main document again
%.pytxcode: %.tex
	$(ECHO) "Compiling latex for pythontex"
	$(PDFLATEX) $<
	$(ECHO) "Creating pythontex"
	$(PYTHONTEX) $<

#Open a viewer if there is none open viewing $(BUILD_DOCUMENT)
view-pdf: $(PDF_VIEWER) open-pdf ## Refresh and open pdf

open-pdf: ## Open pdf build document
	-@ps aux | $(GREP) -v $(GREP) \
	| $(GREP) "$(PDF_VIEWER)" \
	| $(GREP) -q "$(BUILD_DOCUMENT)" \
	||  $(PDF_VIEWER) "$(BUILD_DOCUMENT)" 2>&1 > /dev/null &

mupdf: ## Refresh mupdf
	-@ps aux \
	| $(GREP) -v $(GREP) \
	| $(GREP) "$(PDF_VIEWER)" \
	| $(GREP) "$(BUILD_DOCUMENT)" \
	| $(AWK) '{print $$2}'\
	| $(XARGS) -n1 kill -s SIGHUP

$(FIGS_SUFFIXES): %.asy
	$(ECHO) Compiling $<
	cd $(dir $<) && $(ASYMPTOTE) -f $(shell echo $(suffix $@) | $(TR) -d "\.") $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.gnuplot
	$(ECHO) Compiling $<
	cd $(dir $< ) && $(GNUPLOT) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.sh
	$(ECHO) Compiling $<
	cd $(dir $< ) && $(SH) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.py
	$(ECHO) Compiling $<
	cd $(dir $< ) && $(PY) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.tex
	$(ECHO) Compiling $<
	cd $(dir $< ) && $(PDFLATEX) $(notdir $< ) $(FD_OUTPUT)

$(TOC_FILE): $(TOC_DEP)
	$(ECHO) Creating $(TOC_FILE)
	cd $(dir $(MAIN_SRC) ) && $(PDFLATEX) $(notdir $(MAIN_SRC) ) $(FD_OUTPUT)

$(TOC_DEP): $(MAIN_SRC) $(INCLUDES_DEP)
	$(ECHO) Parsing the toc entries
	@mkdir -p $(dir $@)
	@$(GREP) -E '\\(section|subsection|subsubsection|chapter|part|subsubsubsection).' $(MAIN_SRC) $(INCLUDES)  \
	| $(SED) 's/.*{\(.*\)}.*/\1/' > $@.control
	@if ! diff $@ $@.control > /dev/null ; then mv $@.control $@; fi

$(INCLUDES_DEP): $(MAIN_SRC)
	$(ECHO) Parsing the includes dependencies
	@mkdir -p $(dir $@)
	@echo INCLUDES = \\ > $@
#@ Include statements should not have a .tex extension
#@ so we are forced to add it
	@$(GREP) -E '\\(include|input)[^gp]' $<  \
	| $(SED) 's/.*{\(.*\)}.*/\1.tex \\/' >> $@

$(FIGS_DEP): $(MAIN_SRC) $(INCLUDES_DEP)
	$(ECHO) Parsing the graphics dependencies
	@mkdir -p $(dir $@)
	@echo FIGURES = \\ > $@
	@$(GREP) -E '\\include(graphic|pdf).' $(MAIN_SRC) $(INCLUDES)  \
	| $(SED) 's/.*{\(.*\)}.*/\1 \\/' >> $@

clean: ## Remove build and temporary files
	$(ECHO) Cleaning up...
	-@rm $(patsubst %.tex,%.aux,$(MAIN_SRC)) 2> /dev/null
	-@rm $(patsubst %.tex,%.bbl,$(MAIN_SRC)) 2> /dev/null
	-@rm $(patsubst %.tex,%.blg,$(MAIN_SRC)) 2> /dev/null
	-@rm $(patsubst %.tex,%.fdb_latexmk,$(MAIN_SRC)) 2> /dev/null
	-@rm $(patsubst %.tex,%.fls,$(MAIN_SRC)) 2> /dev/null
	-@rm $(patsubst %.tex,%.log,$(MAIN_SRC)) 2> /dev/null
	-@rm $(patsubst %.tex,%.out,$(MAIN_SRC)) 2> /dev/null
	-@rm $(patsubst %.tex,%.ilg,$(MAIN_SRC)) 2> /dev/null
	-@rm $(patsubst %.tex,%.toc,$(MAIN_SRC)) 2> /dev/null
	-@rm $(PDF_DOCUMENT) 2> /dev/null
	-@rm $(DVI_DOCUMENT) 2> /dev/null
	-@rm $(HTML_DOCUMENT) 2> /dev/null
	-@rm $(MAN_DOCUMENT) 2> /dev/null
#-@rm $(FIGURES) 2> /dev/null
	-@rm $(PYTHONTEX_FILE) 2> /dev/null
	-@rm -rf pythontex-files-main/ 2> /dev/null
	-@rm -rf $(DEPS_DIR) 2> /dev/null

#PANDOC CONVERSIONS
###################

# FIXME: It doesn't work out of the box
REVEALJS_SRC ?= https://github.com/hakimel/reveal.js/
revealjs: $(MAIN_SRC) ## Create a revealjs presentation
	$(ECHO) Creating revealjs presentation...
	$(ECHO) Gettin revealjs from $(REVEALJS_SRC)
	$(GIT) clone --depth=1 $(REVEALJS_SRC) && rm -rf reveal.js/.git
	$(PANDOC) --mathjax -s -f latex -t revealjs $(MAIN_SRC) -o $(HTML_DOCUMENT)
man: $(MAIN_SRC) ## Create a man document
	$(ECHO) Creating man pages...
	$(PANDOC) -s -f latex -t man $(MAIN_SRC) -o $(MAN_DOCUMENT)
html: $(MAIN_SRC) ## Create an html5 document
	$(ECHO) Compiling html document...
	$(PANDOC) --mathjax -s -f latex -t html5 $(MAIN_SRC) -o $(HTML_DOCUMENT)

todo: $(INCLUDES_DEP) ## Print the todos from the main document
	$(ECHO) Parsing \\TODO{} in $(MAIN_SRC)
	@$(SED) -n "/\\TODO{/,/}/\
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
# pdfpc is a nice program for presenting beamer presentations with notes
# and a speaker clock. This target implements a simple script to convert
# the standard \notes{ } beamer  command into pdfpc compatible files, so
# that you can also see your beamer notes inside the pdfpc program.
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
	@mkdir -p $(RELEASES_DIR)
	@for tag in $$($(GIT) tag); do\
		echo "Processing $$tag"; \
		$(GIT) archive --format=$(RELEASES_FMT) --prefix=$$tag/ $$tag > $(RELEASES_DIR)/$$tag.$(RELEASES_FMT); \
	done

dist: $(BUILD_DOCUMENT) ## Create a dist folder with the bare minimum to compile
	$(ECHO) "Creating dist folder"
	@mkdir -p $(DIST_DIR)
	$(ECHO) "Copying the Makefile"
	@cp Makefile $(DIST_DIR)/
	$(ECHO) "Copying the target document"
	@cp $(BUILD_DOCUMENT) $(DIST_DIR)/
	$(ECHO) "Creating folder for dependencies"
	@echo $(DEPENDENCIES)\
	 | $(XARGS) -n1 dirname\
	 | $(XARGS) -n1 -I FF mkdir -p $(DIST_DIR)/FF
	$(ECHO) "Copying dependencies"
	@echo $(DEPENDENCIES)\
	 | $(TR) " " "\n" \
	 | $(XARGS) -n1 -I FF cp FF $(DIST_DIR)/FF

watch: ## Build if changes
	(echo $(MAIN_SRC) | entr make )&
unwatch: ## Cancel Watching
	killall entr

# ===============================
# Update the makefile from source
# ===============================
#
# You can always get the  last latex-makefile version using this target.
# You may override the GH_REPO_FILE to  any path where you save your own
# personal makefile
#
GH_REPO_FILE ?= https://raw.githubusercontent.com/alejandrogallo/latex-makefile/master/Makefile
update: ## Update the makefile from the repository
	$(ECHO) "Getting makefile from $(GH_REPO_FILE)"
	wget $(GH_REPO_FILE) -O Makefile

test: ## See some make variables for debugging
	$(ECHO) DEPENDENCIES =
	@echo $(DEPENDENCIES) | $(TR) " " "\n"
	$(ECHO) "MAIN_SRC    = $(MAIN_SRC)"
	$(ECHO) "Makefiles   = $(MAKEFILE_LIST)"
	$(ECHO) "LINUX       = $(LINUX)"
	$(ECHO) "OSX         = $(OSX)"
	$(ECHO) "readlink    = $(READLINK)"
	$(ECHO) "PDF_VIEWER  = $(PDF_VIEWER)"
	$(ECHO) "$(call discoverMain)"

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
	@echo "$(PURGE_SUFFIXES)" \
	| $(TR) "%" "*" \
	| $(XARGS) -n1  $(FIND) . -name \
	| while read i; do echo $$i ; rm $$i; done


help: ## Prints help for targets with comments
	@$(AWK) 'BEGIN {FS = ":.*?## "}; /^[a-zA-Z_-]+:.*?## .*$$/{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


# vim: nospell fdm=marker
