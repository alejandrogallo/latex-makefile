include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
%.tex: %.sh
	$(ARROW) Creating $@ from $<
	$(DBG_FLAG)cd $(dir $<) && $(SH) $(notdir $<) $(FD_OUTPUT)

%.tex: %.py
	$(ARROW) Creating $@ from $<
	$(DBG_FLAG)cd $(dir $<) && $(PY) $(notdir $<) $(FD_OUTPUT)

$(AUX_FILE):
	$(ARROW) Creating $@
	$(DBG_FLAG)$(PDFLATEX) $(BUILD_DIR_FLAG) $(MAIN_SRC) $(FD_OUTPUT)

dnl vim: noexpandtab
