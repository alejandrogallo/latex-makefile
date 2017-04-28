BROWSER ?= firefox
view-html: $(BUILD_DOCUMENT)
	$(DEBUG)($(BROWSER) $(BUILD_DOCUMENT) &)&
