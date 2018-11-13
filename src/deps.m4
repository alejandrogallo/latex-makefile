include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
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
	$(DBG_FLAG)$(GREP) --no-filename -E '\\`include'(graphic|pdf).' $(TEXFILES)  \
	| $(removeTexComments) \
	| $(SED) -n 's/.*{\([^{}]\+\)}.*/\1 \\/p' >> $@

figs: $(FIGURES) ## Make figures
deps: $(FIGS_DEP) ## Parse dependencies for the main texfile

