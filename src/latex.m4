include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
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
removeTexComments=$(SED) "s/\([^\\]\)%.*/\1/g; s/^%.*//g"

TEX_INCLUDES_REGEX = \in\(clude\|put\)\s*[{]\s*
define recursiveDiscoverIncludes
$(shell \
	files=$(1);\
	for i in $$(seq 1 $(2)); do \
		files="$$(\
			cat $$files 2> /dev/null\
					| $(removeTexComments) \
					| $(SED) 's/$(TEX_INCLUDES_REGEX)/\n&/g' \
					| $(SED) -n '/$(TEX_INCLUDES_REGEX)/p' \
					| $(SED) 's/$(TEX_INCLUDES_REGEX)//' \
					| $(SED) 's/\.tex//g' \
					| $(SED) 's/}.*//g' \
					| $(SED) 's/\s*$$//g' \
					| $(SED) 's/\(.*\)/\1.tex /' \
		)"; \
		$(log-debug) $$i th iteration includes; \
		$(log-debug) $$files; \
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

ifneq ($(strip $(MAIN_SRC)),) # Do this only if MAIN_SRC is defined

BUILD_DOCUMENT       = $(patsubst %.tex,%.$(FMT),$(MAIN_SRC))
TOC_FILE             = $(patsubst %.tex,$(BUILD_DIR)/%.toc,$(MAIN_SRC))
BIBITEM_FILES        = $(patsubst %.tex,$(BUILD_DIR)/%.bbl,$(MAIN_SRC))
AUX_FILE             = $(patsubst %.tex,$(BUILD_DIR)/%.aux,$(MAIN_SRC))
PYTHONTEX_FILE       = $(patsubst %.tex,$(BUILD_DIR)/%.pytxcode,$(MAIN_SRC))
PDFPC_FILE           = $(patsubst %.tex,%.pdfpc,$(MAIN_SRC))
PACKAGES_FILES_BUILD = $(patsubst $(PACKAGES_DIR)/%,$(BUILD_DIR)/%,$(PACKAGES_FILES))

endif #MAIN_SRC exists


$(AUX_FILE):
	$(ECHO) $(call print-cmd-name,$(PDFLATEX)) $@
	$(DBG_FLAG)$(PDFLATEX) $(BUILD_DIR_FLAG) $(MAIN_SRC) $(FD_OUTPUT)

# Default dependencies for `BUILD_DOCUMENT`
DEFAULT_DEPENDENCIES ?= \
$(BUILD_DIR) \
$(MAIN_SRC) \
$(INCLUDES) \
$(PACKAGES_FILES_BUILD) \
$(FIGURES) \
$(if $(call hasToc,$(MAIN_SRC)),$(TOC_FILE),$(AUX_FILE)) \
$(if $(wildcard $(BIBTEX_FILES)),$(BIBITEM_FILES)) \
$(if $(WITH_PYTHONTEX),$(PYTHONTEX_FILE)) \
$(if $(CHECK_SPELL),spelling) \

# General dependencies for `BUILD_DOCUMENT`
DEPENDENCIES ?= $(DEFAULT_DEPENDENCIES)

dnl vim:ft=make:noexpandtab:
