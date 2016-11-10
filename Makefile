#local configuration
-include config.mk
# PARAMETERS, OVERRIDE THESE
SOURCE_DOCUMENT ?= main.tex
BIBTEX_FILE     ?= $(patsubst %.tex,%.bib,$(SOURCE_DOCUMENT))
DEPS_DIR        ?= deps
PDF_VIEWER      ?= mupdf
LATEX           ?= pdflatex
PDFLATEX        ?= pdflatex
ASYMPTOTE       ?= asy
SH              ?= bash
PY              ?= python
GREP            ?= grep
SED             ?= sed
AWK             ?= awk
FIND            ?= find
GNUPLOT         ?= gnuplot
PANDOC          ?= pandoc
BIBTEX          ?= bibtex
# Use greadlink in osx
READLINK        ?= readlink
DEPENDENCIES    ?=
FIGURES         ?=
# sources included through \include
INCLUDES        ?=
FIGS_DIR        ?= images
# it generates the figures needed
# if 0 it looks for all scripts in FIGS_DIR
AUTO_FIG_DEPS   ?= 1
AUTO_INC_DEPS   ?= 1
WITH_PYTHONTEX  ?= 0
# Do you use pythontex?
PYTHONTEX       ?= pythontex
ECHO            ?= @echo "\033[0;35m===>\033[0m"
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


PDF_DOCUMENT   = $(shell $(READLINK) -f $(patsubst %.tex,%.pdf,$(SOURCE_DOCUMENT)))
DVI_DOCUMENT   = $(shell $(READLINK) -f $(patsubst %.tex,%.dvi,$(SOURCE_DOCUMENT)))
MAN_DOCUMENT   = $(patsubst %.tex,%.1,$(SOURCE_DOCUMENT))
HTML_DOCUMENT  = $(patsubst %.tex,%.html,$(SOURCE_DOCUMENT))
TOC_FILE       = $(patsubst %.tex,%.toc,$(SOURCE_DOCUMENT))
BIBITEM_FILE   = $(patsubst %.bib,%.bbl,$(BIBTEX_FILE))
PYTHONTEX_FILE = $(patsubst %.tex,%.pytxcode,$(SOURCE_DOCUMENT))
PDFPC_FILE     = $(shell $(READLINK) -f $(patsubst %.tex,%.pdfpc,$(SOURCE_DOCUMENT)))
FIGS_SUFFIXES  = %.pdf %.eps %.png %.jpg %.jpeg %.gif %.dvi %.bmp %.svg %.ps
PURGE_SUFFIXES = %.aux %.bbl %.blg %.fdb_latexmk %.fls %.log %.out %.ilg %.toc
BUILD_DOCUMENT = $(PDF_DOCUMENT)

# These files are to keep track of the dependencies for
# latex or pdf includes, table of contents generation or
# figure recognition
TOC_DEP        = $(DEPS_DIR)/toc.d
INCLUDES_DEP   = $(DEPS_DIR)/includes.d
FIGS_DEP       = $(DEPS_DIR)/figs.d

ifeq ($(AUTO_INC_DEPS),1)
	include $(INCLUDES_DEP)
endif

ifneq ($(AUTO_FIG_DEPS),1)
# for libs and such
	IGNORE_FIGS       = $(FIGS_DIR)/atoms.asy $(FIGS_DIR)/resources.asy
	ASY_FILES         = $(filter-out $(IGNORE_FIGS),$(shell $(FIND) $(FIGS_DIR) | $(GREP) .asy))
	ASY_PDF_FILES     = $(patsubst %.asy,%.pdf,$(ASY_FILES))
	GNUPLOT_FILES     = $(filter-out $(IGNORE_FIGS),$(shell $(FIND) $(FIGS_DIR) | $(GREP) .gnuplot))
	GNUPLOT_PDF_FILES = $(patsubst %.gnuplot,%.pdf,$(GNUPLOT_FILES))
	TEX_FILES         = $(filter-out $(IGNORE_FIGS),$(shell $(FIND) $(FIGS_DIR) | $(GREP) .tex))
	TEX_PDF_FILES     = $(patsubst %.tex,%.pdf,$(TEX_FILES))
	FIGURES=$(TEX_PDF_FILES) $(ASY_PDF_FILES) $(GNUPLOT_PDF_FILES)
else
	include $(FIGS_DEP)
endif

.PHONY: view-pdf open-pdf $(PDF_VIEWER) todo help test force purge dist

# Main dependencies for BUILD_DOCUMENT
DEPENDENCIES += $(SOURCE_DOCUMENT) $(INCLUDES) $(FIGURES) $(TOC_FILE)

# Bibtex dependency
ifneq ("$(wildcard $(BIBTEX_FILE))","")
	DEPENDENCIES += $(BIBITEM_FILE)
endif

# Pythontex support
ifneq ($(WITH_PYTHONTEX),0)
	DEPENDENCIES += $(PYTHONTEX_FILE)
endif


all: $(BUILD_DOCUMENT) view-pdf ## (Default) Create BUILD_DOCUMENT


$(BUILD_DOCUMENT): $(DEPENDENCIES)

force: ## Force creation of BUILD_DOCUMENT
	-rm $(BUILD_DOCUMENT)
	$(MAKE) $(BUILD_DOCUMENT)

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
	| xargs -n1 kill -s SIGHUP

$(FIGS_SUFFIXES): %.asy
	$(ECHO) Compiling $<
	cd $(dir $<) && $(ASYMPTOTE) -f $(shell echo $(suffix $@) | tr -d "\.") $(notdir $< ) $(FD_OUTPUT)

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
	cd $(dir $(SOURCE_DOCUMENT) ) && $(PDFLATEX) $(notdir $(SOURCE_DOCUMENT) ) $(FD_OUTPUT)

$(TOC_DEP): $(SOURCE_DOCUMENT) $(INCLUDES_DEP)
	$(ECHO) Parsing the toc entries
	@mkdir -p $(dir $@)
	@$(GREP) -E '\\(section|subsection|subsubsection|chapter|part|subsubsubsection).' $(SOURCE_DOCUMENT) $(INCLUDES)  \
	| $(SED) 's/.*{\(.*\)}.*/\1/' > $@.control
	@if ! diff $@ $@.control > /dev/null ; then mv $@.control $@; fi

$(INCLUDES_DEP): $(SOURCE_DOCUMENT)
	$(ECHO) Parsing the includes dependencies
	@mkdir -p $(dir $@)
	@echo INCLUDES = \\ > $@
#@ Include statements should not have a .tex extension
#@ so we are forced to add it
	@$(GREP) -E '\\(include|input)[^gp]' $<  \
	| $(SED) 's/.*{\(.*\)}.*/\1.tex \\/' >> $@

$(FIGS_DEP): $(SOURCE_DOCUMENT) $(INCLUDES_DEP)
	$(ECHO) Parsing the graphics dependencies
	@mkdir -p $(dir $@)
	@echo FIGURES = \\ > $@
	@$(GREP) -E '\\include(graphic|pdf).' $(SOURCE_DOCUMENT) $(INCLUDES)  \
	| $(SED) 's/.*{\(.*\)}.*/\1 \\/' >> $@

#.PHONY: $(DEPS_DIR)/includes.d $(DEPS_DIR)/figures.d
# vim-run: clear; make deps/includes.d ; make test

clean: ## Remove build and temporary files
	$(ECHO) Cleaning up...
	-@rm $(patsubst %.tex,%.aux,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(patsubst %.tex,%.bbl,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(patsubst %.tex,%.blg,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(patsubst %.tex,%.fdb_latexmk,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(patsubst %.tex,%.fls,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(patsubst %.tex,%.log,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(patsubst %.tex,%.out,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(patsubst %.tex,%.ilg,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(patsubst %.tex,%.toc,$(SOURCE_DOCUMENT)) 2> /dev/null
	-@rm $(PDF_DOCUMENT) 2> /dev/null
	-@rm $(DVI_DOCUMENT) 2> /dev/null
	-@rm $(HTML_DOCUMENT) 2> /dev/null
	-@rm $(MAN_DOCUMENT) 2> /dev/null
#-@rm $(FIGURES) 2> /dev/null
	-@rm $(PYTHONTEX_FILE) 2> /dev/null
	-@rm -rf pythontex-files-main/ 2> /dev/null
	-@rm -rf $(DEPS_DIR) 2> /dev/null

#PANDOC CONVERSIONS
revealjs: $(SOURCE_DOCUMENT) ## Create a revealjs presentation
	$(ECHO) Creating revealjs presentation...
	$(PANDOC) --mathjax -s -f latex -t revealjs $(SOURCE_DOCUMENT)
man: $(SOURCE_DOCUMENT) ## Create a man document
	$(ECHO) Creating man pages...
	$(PANDOC) -s -f latex -t man $(SOURCE_DOCUMENT) -o $(MAN_DOCUMENT)
html: $(SOURCE_DOCUMENT) ## Create an html5 document
	$(ECHO) Compiling html document...
	$(PANDOC) --mathjax -s -f latex -t html5 $(SOURCE_DOCUMENT) -o $(HTML_DOCUMENT)

todo: $(INCLUDES_DEP) ## Print the todos from the main document
	$(ECHO) Parsing \\TODO{} in $(SOURCE_DOCUMENT)
	@$(SED) -n "/\\TODO{/,/}/\
	{\
		s/.TODO/===/; \
		s/[{]//g; \
		s/[}]/===/g; \
		p\
	}" $(SOURCE_DOCUMENT) $(INCLUDES)

pdf-presenter-console: $(PDFPC_FILE) ## Create annotations file for the pdfpc program
$(PDFPC_FILE): $(SOURCE_DOCUMENT)
	echo "[file]" > $@
	echo "$(PDF_DOCUMENT)" >> $@
	echo "[notes]" >> $@
	cat $(SOURCE_DOCUMENT) | $(AWK) '\
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

dist: $(BUILD_DOCUMENT) ## Create a dist folder with the bare minimum to compile
	$(ECHO) "Creating dist folder"
	@mkdir -p $(DIST_DIR)
	$(ECHO) "Copying the Makefile"
	@cp Makefile $(DIST_DIR)/
	$(ECHO) "Copying the target document"
	@cp $(BUILD_DOCUMENT) $(DIST_DIR)/
	$(ECHO) "Creating folder for dependencies"
	@echo $(DEPENDENCIES)\
	 | xargs -n1 dirname\
	 | xargs -n1 -I FF mkdir -p $(DIST_DIR)/FF
	$(ECHO) "Copying dependencies"
	@echo $(DEPENDENCIES)\
	 | tr " " "\n" \
	 | xargs -n1 -I FF cp FF $(DIST_DIR)/FF

watch: ## Build if changes
	(echo $(SOURCE_DOCUMENT) | entr make )&
unwatch: ## Cancel Watching
	killall entr

test: ## See some make variables for debugging
	$(ECHO) DEPENDENCIES
	$(ECHO) ============
	$(ECHO) $(DEPENDENCIES) | tr " " "\n"
	@echo $(MAKEFILE_LIST)

tags: $(SOURCE_DOCUMENT) $(INCLUDES_DEP) ## Create TeX exhuberant ctags
	ctags --language-force=tex -R *

purge: clean ## Remove recursively with suffixes in PURGE_SUFFIXES
	$(ECHO) Purging files across directories... be careful
	@echo "$(PURGE_SUFFIXES)" \
	| tr "%" "*" \
	| xargs -n1  $(FIND) . -name \
	| while read i; do echo $$i ; rm $$i; done


help: ## Prints help for targets with comments
	@$(AWK) 'BEGIN {FS = ":.*?## "}; /^[a-zA-Z_-]+:.*?## .*$$/{printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)


# vim: nospell fdm=marker
