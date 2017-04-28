
MAKEFILE_VERSION = syscmd(`git describe --tags')dnl
MAKEFILE_DATE = syscmd(`date +"%d-%m-%Y %H:%M"')dnl

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

include(os.m4)

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
# Find utility
FIND       ?= find
# sed program version
SED        ?= $(if $(OSX),gsed,sed)
AWK        ?= $(if $(OSX),gawk,awk)
SPELLER    ?= aspell
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
CHECK_SPELL?=
SPELL_LANG ?= en
SPELL_DIR  ?= .spell
# Eps to pdf converter
EPS2PDF    ?= epstopdf

ifndef QQUIET

ifeq ($(strip $(WITH_COLOR)),1)
COLOR_B         ?= $(if $(TPUT),$(shell $(TPUT) setaf 5),"\033[0;35m")
COLOR_E         ?= $(if $(TPUT),$(shell $(TPUT) sgr0),"\033[0m")
ARROW           ?= @echo "$(COLOR_B)===>$(COLOR_E)"
else
ARROW           ?= @echo "===>"
endif #WITH_COLOR

ECHO            ?= @echo

else
ARROW           := @ > /dev/null echo
ECHO            := @ > /dev/null echo
endif #QQUIET

# Remove comments from some file, this variables is intended to be put
# in a shell call for processing of TeX files
removeTexComments=$(SED) "s/[^\\]%.*//g; s/^%.*//g"

# Function to try to discover automatically the main latex document
define discoverMain
$(shell \
	$(GREP) -H '\\begin{document}' *.tex 2>/dev/null \
	| $(removeTexComments) \
	| head -1 \
	| $(AWK) -F ":" '{print $$1}' \
)
endef

define discoverBibtexFiles
$(shell \
	$(GREP) -E '\\bibliography\s*{' $(1) 2> /dev/null  \
		| $(removeTexComments) \
		| $(SED) 's/.*\\bibliography//' \
		| $(SED) 's/\.bib//g' \
		| $(TR) "," "\n" \
		| $(TR) -d "{}" \
		| $(SED) 's/\s*$$/.bib /' \
		| sort \
		| uniq \
)
endef

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

# Main texfile in the current directory
MAIN_SRC        ?= $(call discoverMain)
# Format to build to
FMT             ?= pdf
# Folder to keep makefile dependencies
DEPS_DIR        ?= .deps
# If `pdf` should be previewed after building
VIEW            ?= 1
# General dependencies for BUILD_DOCUMENT
DEPENDENCIES    ?=
# Figures included in all texfiles
FIGURES         ?=
# Depth for discovering automatically included texfiles
INCLUDES_REC    ?= 3
# Texfiles included in the main tex file
INCLUDES        ?= $(call recursiveDiscoverIncludes,$(MAIN_SRC),$(INCLUDES_REC))
# All `texfiles` in the project
TEXFILES        ?= $(MAIN_SRC) $(INCLUDES)
# Bibtex files in the current directory
BIBTEX_FILES     ?= $(call discoverBibtexFiles,$(TEXFILES))
# If pythontex is being used
WITH_PYTHONTEX  ?=
# If secondary programs output is shown
QUIET           ?= 0
# Source directory
PREFIX          ?= $(PWD)
# Folder to build the project
BUILD_DIR       ?= .
# Build dir flag for latex.
# If `BUILD_DIR = .` then `BUILD_DIR_FLAG` is not defined,
# else `BUILD_DIR = -output-directory $(BUILD_DIR)`
BUILD_DIR_FLAG  ?= $(if \
                   $(filter-out \
                   .,$(strip $(BUILD_DIR))),-output-directory $(BUILD_DIR))
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
$(PACKAGES_DIR)/*.clo \
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
BIBITEM_FILES        = $(patsubst %.tex,$(BUILD_DIR)/%.bbl,$(MAIN_SRC))
AUX_FILE             = $(patsubst %.tex,$(BUILD_DIR)/%.aux,$(MAIN_SRC))
PYTHONTEX_FILE       = $(patsubst %.tex,$(BUILD_DIR)/%.pytxcode,$(MAIN_SRC))
PDFPC_FILE           = $(patsubst %.tex,%.pdfpc,$(MAIN_SRC))
PACKAGES_FILES_BUILD = $(patsubst $(PACKAGES_DIR)/%,$(BUILD_DIR)/%,$(PACKAGES_FILES))
FIGS_SUFFIXES        = %.pdf %.eps %.png %.jpg %.jpeg %.gif %.dvi %.bmp %.svg \
                       %.ps
PURGE_SUFFIXES       = %.aux %.bbl %.blg %.fdb_latexmk %.fls %.log %.out \
                       %.ilg %.toc %.nav %.snm
SUPPORTED_SUFFIXES   = %.pdf %.div %.ps %.eps %.1 %.html

# These files  are to keep  track of the  dependencies for latex  or pdf
# includes, table of contents generation or figure recognition
#
TOC_DEP        = $(strip $(DEPS_DIR))/toc.d
FIGS_DEP       = $(strip $(DEPS_DIR))/figs.d

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),help)
-include $(FIGS_DEP)
endif
endif

endif #MAIN_SRC exists



# Main dependencies for BUILD_DOCUMENT
######################################

DEPENDENCIES += \
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

deps: $(FIGS_DEP) ## Parse dependencies for the main texfile

all: $(FMT) $(if $(VIEW),view-$(FMT)) ## (Default) Create BUILD_DOCUMENT

$(BUILD_DOCUMENT): $(DEPENDENCIES)

include(build-dir.m4)

# =================
# Force compilation
# =================
#
# This makefile only compiles the TeX document if it is strictly necessary, so
# sometimes to force compilation this target comes in handy.
#
force: ## Force creation of BUILD_DOCUMENT
	$(DEBUG)$(MAKE) --no-print-directory -W $(MAIN_SRC) $(BUILD_DOCUMENT)

include(html.m4)

include(bilbiography.m4)

include(pythontex.m4)

include(figure-targets.m4)

include(document-targets.m4)

include(pdf-viewer.m4)

include(deps.m4)

include(clean.m4)

include(todo.m4)

include(pandoc.m4)

include(pdfpc.m4)

include(release.m4)

include(dist.m4)

include(diff.m4)

include(spelling.m4)

include(lint.m4)

include(watch.m4)

include(update.m4)

include(tags.m4)

include(print-variable.m4)

include(help.m4)

include(help-target.m4)

# vim: cc=80

dnl vim: noexpandtab
