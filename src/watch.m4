include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
watch: ## Build if changes
	$(DBG_FLAG)(echo $(TEXFILES) $(BIBTEX_FILES) | $(TR) " " "\n" | entr make &)&

unwatch: ## Cancel Watching
	killall entr

dnl vim:ft=make:noexpandtab:
