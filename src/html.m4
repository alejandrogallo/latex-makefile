include_once(log.m4)dnl
dnl
BROWSER ?= firefox
view-html: $(BUILD_DOCUMENT)
	$(DEBUG)($(BROWSER) $(BUILD_DOCUMENT) &)&

dnl vim: noexpandtab
