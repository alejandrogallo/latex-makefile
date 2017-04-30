include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
BROWSER ?= firefox
view-html: $(BUILD_DOCUMENT)
	$(DBG_FLAG)($(BROWSER) $(BUILD_DOCUMENT) &)&

dnl vim: noexpandtab
