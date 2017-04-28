watch: ## Build if changes
	(echo $(TEXFILES) $(BIBTEX_FILES) | $(TR) " " "\n" | entr make &)&
unwatch: ## Cancel Watching
	killall entr

dnl vim: noexpandtab
