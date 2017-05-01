include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
BROWSER ?= firefox
view-html: $(BUILD_DOCUMENT)
	$(DBG_FLAG)($(BROWSER) $(BUILD_DOCUMENT) &)&

dnl vim: noexpandtab
