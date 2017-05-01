include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
# Function to try to discover automatically the main latex document
define discoverMain
$(shell \
	$(GREP) -H '\\begin{document}' *.tex 2>/dev/null \
	| $(removeTexComments) \
	| head -1 \
	| $(AWK) -F ":" '{print $$1}' \
)
endef

# Remove comments from some file, this variables is intended to be put
# in a shell call for processing of TeX files
removeTexComments=$(SED) "s/[^\\]%.*//g; s/^%.*//g"

TEX_INCLUDES_REGEX = \in\(clude\|put\)\s*[{]\s*
define recursiveDiscoverIncludes
$(shell \
	files=$(1);\
	for i in $$(seq 1 $(2)); do \
		files="$$(\
			cat $$files 2> /dev/null\
					| $(removeTexComments) \
					| $(SED) 's/$(TEX_INCLUDES_REGEX)/\n&/g' \
					| $(SED) -n '/$(TEX_INCLUDES_REGEX)/p' \
					| $(SED) 's/$(TEX_INCLUDES_REGEX)//' \
					| $(SED) 's/\.tex//g' \
					| $(SED) 's/}.*//g' \
					| $(SED) 's/\s*$$//g' \
					| $(SED) 's/\(.*\)/\1.tex /' \
		)"; \
		$(log-debug) $$i th iteration includes; \
		$(log-debug) $$files; \
		test -n "$$files" || break; \
		echo $$files; \
	done \
)
endef

define hasToc
$(shell\
	$(GREP) '\\tableofcontents' $(1) \
	| $(removeTexComments) \
	| $(SED) "s/ //g" \
)
endef

$(AUX_FILE):
	$(ECHO) $(call print-cmd-name,$(PDFLATEX)) $@
	$(DBG_FLAG)$(PDFLATEX) $(BUILD_DIR_FLAG) $(MAIN_SRC) $(FD_OUTPUT)

dnl vim: noexpandtab
