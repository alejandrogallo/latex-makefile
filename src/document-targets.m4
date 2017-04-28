%.tex: %.sh
	$(ARROW) Creating $@ from $<
	$(DEBUG)cd $(dir $<) && $(SH) $(notdir $<) $(FD_OUTPUT)

%.tex: %.py
	$(ARROW) Creating $@ from $<
	$(DEBUG)cd $(dir $<) && $(PY) $(notdir $<) $(FD_OUTPUT)

$(AUX_FILE):
	$(ARROW) Creating $@
	$(DEBUG)$(PDFLATEX) $(BUILD_DIR_FLAG) $(MAIN_SRC) $(FD_OUTPUT)

dnl vim: noexpandtab
