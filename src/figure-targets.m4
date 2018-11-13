include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
FIGS_SUFFIXES = %.pdf %.eps %.png %.jpg %.jpeg %.gif %.dvi %.bmp %.svg %.ps
# Eps to pdf converter
EPS2PDF ?= epstopdf
# For asymptote figures
ASYMPTOTE ?= asy
# Gnuplot interpreter
GNUPLOT ?= gnuplot

$(FIGS_SUFFIXES): %.asy
	$(ECHO) $(call print-cmd-name,$(ASYMPTOTE)) $@
	$(DBG_FLAG)cd $(dir $<) && $(ASYMPTOTE) -f \
		$(shell echo $(suffix $@) | $(TR) -d "\.") $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.gnuplot
	$(ECHO) $(call print-cmd-name,$(GNUPLOT)) $@
	$(DBG_FLAG)cd $(dir $< ) && $(GNUPLOT) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.sh
	$(ECHO) $(call print-cmd-name,$(SH)) $@
	$(DBG_FLAG)cd $(dir $< ) && $(SH) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.py
	$(ECHO) $(call print-cmd-name,$(PY)) $@
	$(DBG_FLAG)cd $(dir $< ) && $(PY) $(notdir $< ) $(FD_OUTPUT)

$(FIGS_SUFFIXES): %.tex
	$(ECHO) $(call print-cmd-name,$(PDFLATEX)) $@
	$(DBG_FLAG)mkdir -p $(dir $<)/$(BUILD_DIR)
	$(DBG_FLAG)cd $(dir $<) && $(PDFLATEX) \
		$(BUILD_DIR_FLAG) $(notdir $*.tex ) $(FD_OUTPUT)
ifneq ($(strip $(BUILD_DIR)),.)
	-$(DBG_FLAG)test ! "$@ = *.aux" || cp \
		$(PWD)/$(dir $<)/$(BUILD_DIR)/$(notdir $@) $(PWD)/$(dir $<)/$(notdir $@)
endif

%.pdf: %.eps
	$(ECHO) $(call print-cmd-name,$(EPS2PDF)) $@
	$(DBG_FLAG)cd $(dir $< ) && $(EPS2PDF) $(notdir $< ) $(FD_OUTPUT)

dnl vim:ft=make:noexpandtab:
