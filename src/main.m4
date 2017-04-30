include(include_once.m4)
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

include_once(os.m4)
include_once(shell-utils.m4)
include_once(latex.m4)

# Folder to build the project
BUILD_DIR ?= .
# Shell utilities
LATEX ?= pdflatex
# For creating differences
LATEXDIFF ?= latexdiff
# Main pdflatex engine
PDFLATEX ?= pdflatex

include_once(log.m4)

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

include_once(deps.m4)
include_once(bibliography.m4)

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

include_once(build-dir.m4)

include_once(libraries.m4)

include_once(html.m4)

include_once(pythontex.m4)

include_once(figure-targets.m4)

include_once(document-targets.m4)

include_once(pdf-viewer.m4)

include_once(clean.m4)

include_once(todo.m4)

include_once(pandoc.m4)

include_once(pdfpc.m4)

include_once(release.m4)

include_once(dist.m4)

include_once(diff.m4)

include_once(spelling.m4)

include_once(lint.m4)

include_once(watch.m4)

include_once(update.m4)

include_once(tags.m4)

include_once(print-variable.m4)

include_once(help.m4)

include_once(help-target.m4)

# vim: cc=80

dnl vim: noexpandtab
