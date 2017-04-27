$(TOC_FILE): $(TOC_DEP)
	$(ARROW) Creating $(TOC_FILE)
	$(DEBUG)mkdir -p $(BUILD_DIR)
	$(DEBUG)cd $(dir $(MAIN_SRC) ) && $(PDFLATEX) \
		$(BUILD_DIR_FLAG) $(notdir $(MAIN_SRC) ) $(FD_OUTPUT)

$(TOC_DEP): $(TEXFILES)
	$(ARROW) Parsing table of contents
	$(DEBUG)mkdir -p $(dir $@)
	$(DEBUG)$(GREP) -E \
		'\\(section|subsection|subsubsection|chapter|part|subsubsubsection).' \
		$(TEXFILES)  \
		| $(removeTexComments) \
		| $(SED) 's/.*{\(.*\)}.*/\1/' > $@.control
	$(DEBUG)if ! diff $@ $@.control 2>&1 > /dev/null ; then mv $@.control $@; fi

$(FIGS_DEP): $(TEXFILES)
	$(ARROW) Parsing the graphics dependencies
	$(DEBUG)mkdir -p $(dir $@)
	$(DEBUG)echo FIGURES = \\ > $@
	$(DEBUG)$(GREP) --no-filename -E '\\`include'(graphic|pdf).' $(TEXFILES)  \
	| $(removeTexComments) \
	| $(SED) -n 's/.*{\([^{}]\+\)}.*/\1 \\/p' >> $@
