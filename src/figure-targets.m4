$(FIGS_SUFFIXES): %.asy
	$(ARROW) Compiling $<
	$(DEBUG)cd $(dir $<) && $(ASYMPTOTE) -f \
		$(shell echo $(suffix $@) | $(TR) -d "\.") $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.gnuplot
	$(ARROW) Compiling $<
	$(DEBUG)cd $(dir $< ) && $(GNUPLOT) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.sh
	$(ARROW) Compiling $<
	$(DEBUG)cd $(dir $< ) && $(SH) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.py
	$(ARROW) Compiling $<
	$(DEBUG)cd $(dir $< ) && $(PY) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.tex
	$(ARROW) Compiling $< into $@
	$(DEBUG)mkdir -p $(dir $<)/$(BUILD_DIR)
	$(DEBUG)cd $(dir $<) && $(PDFLATEX) \
		$(BUILD_DIR_FLAG) $(notdir $*.tex ) $(FD_OUTPUT)
ifneq ($(strip $(BUILD_DIR)),.)
	-$(DEBUG)test ! "$@ = *.aux" || cp \
		$(PWD)/$(dir $<)/$(BUILD_DIR)/$(notdir $@) $(PWD)/$(dir $<)/$(notdir $@)
endif

%.pdf: %.eps
	$(ARROW) Converting $< into $@
	$(DEBUG)cd $(dir $< ) && $(EPS2PDF) $(notdir $< ) $(FD_OUTPUT)

dnl vim: noexpandtab
