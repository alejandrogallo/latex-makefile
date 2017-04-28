# Eps to pdf converter
EPS2PDF ?= epstopdf
# For asymptote figures
ASYMPTOTE ?= asy
# Gnuplot interpreter
GNUPLOT ?= gnuplot

$(FIGS_SUFFIXES): %.asy
	$(ARROW) $(call print-cmd-name,$(ASYMPTOTE)) $@
	$(DEBUG)cd $(dir $<) && $(ASYMPTOTE) -f \
		$(shell echo $(suffix $@) | $(TR) -d "\.") $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.gnuplot
	$(ARROW) $(call print-cmd-name,$(GNUPLOT)) $@
	$(ARROW) Compiling $<
	$(DEBUG)cd $(dir $< ) && $(GNUPLOT) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.sh
	$(ARROW) $(call print-cmd-name,$(SH)) $@
	$(DEBUG)cd $(dir $< ) && $(SH) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.py
	$(ARROW) $(call print-cmd-name,$(PY)) $@
	$(ARROW) Compiling $<
	$(DEBUG)cd $(dir $< ) && $(PY) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.tex
	$(ARROW) $(call print-cmd-name,$(PDFLATEX)) $@
	$(DEBUG)mkdir -p $(dir $<)/$(BUILD_DIR)
	$(DEBUG)cd $(dir $<) && $(PDFLATEX) \
		$(BUILD_DIR_FLAG) $(notdir $*.tex ) $(FD_OUTPUT)
ifneq ($(strip $(BUILD_DIR)),.)
	-$(DEBUG)test ! "$@ = *.aux" || cp \
		$(PWD)/$(dir $<)/$(BUILD_DIR)/$(notdir $@) $(PWD)/$(dir $<)/$(notdir $@)
endif

%.pdf: %.eps
	$(ARROW) $(call print-cmd-name,$(EPS2PDF)) $@
	$(DEBUG)cd $(dir $< ) && $(EPS2PDF) $(notdir $< ) $(FD_OUTPUT)

dnl vim: noexpandtab
