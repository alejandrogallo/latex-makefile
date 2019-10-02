include(common-makefile/src/include_once.m4)
define(_MAKEFILE_AUTHOR, Alejandro Gallo)dnl
define(_MAKEFILE_URL, https://github.com/alejandrogallo/latex-makefile)dnl
include_once(common-makefile/src/version.m4)

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

include_once(common-makefile/src/os.m4)
include_once(common-makefile/src/shell-utils.m4)

# Folder to build the project
BUILD_DIR ?= .
# Shell utilities
LATEX ?= pdflatex
# Main pdflatex engine
PDFLATEX ?= pdflatex

include_once(common-makefile/src/log.m4)

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

include_once(libraries.m4)

include_once(latex.m4)

PURGE_SUFFIXES       = %.aux %.bbl %.blg %.fdb_latexmk %.fls %.log %.out \
                       %.ilg %.toc %.nav %.snm
SUPPORTED_SUFFIXES   = %.pdf %.div %.ps %.eps %.1 %.html

include_once(deps.m4)
include_once(bibliography.m4)

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

include_once(figure-targets.m4)

include_once(document-targets.m4)

include_once(pdf-viewer.m4)

include_once(clean.m4)

include_once(release.m4)

include_once(dist.m4)

include_once(diff.m4)

include_once(spelling.m4)

include_once(lint.m4)

define(
_MAKEFILE_UPDATE_URL,
$(shell \
curl https://api.github.com/repos/alejandrogallo/latex-makefile/releases/latest | \
$(SED) -n 's/.*browser_download_url":.*"\(.*\)"/\1/p' \
)
)dnl
include_once(common-makefile/src/update.m4)

include_once(tags.m4)

include_once(common-makefile/src/print-variable.m4)
include_once(common-makefile/src/help.m4)
include_once(common-makefile/src/help-target.m4)


dnl vim:ft=make:noexpandtab:
