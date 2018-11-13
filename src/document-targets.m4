include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
%.tex: %.sh
	$(ECHO) $(call print-cmd-name,$(SH)) $@
	$(DBG_FLAG)cd $(dir $<) && $(SH) $(notdir $<) $(FD_OUTPUT)

%.tex: %.py
	$(ECHO) $(call print-cmd-name,$(PY)) $@
	$(DBG_FLAG)cd $(dir $<) && $(PY) $(notdir $<) $(FD_OUTPUT)

%.tex: %.pl
	$(ECHO) $(call print-cmd-name,$(PERL)) $@
	$(DBG_FLAG)cd $(dir $<) && $(PERL) $(notdir $<) $(FD_OUTPUT)

dnl vim:ft=make:noexpandtab:
