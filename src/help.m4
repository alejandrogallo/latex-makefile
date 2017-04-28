# ================
# Print quick help
# ================
#
# It prints a quick help in the terminal
help: ## Prints help for targets with comments
	$(DEBUG)$(or $(AWK),awk) ' \
		BEGIN {FS = ":.*?## "}; \
		/^## *<<HELP/,/^## *HELP/ { \
			help=$$1; \
			gsub("#","",help); \
			if (! match(help, "HELP")) \
				print help ; \
		}; \
		/^[a-zA-Z0-9_\-.]+:.*?## .*$$/{ \
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$2 ; \
		};' \
		$(MAKEFILE_LIST)
	@echo ""
	@echo "  $(MAKEFILE_VERSION)"
	@echo "  https://github.com/alejandrogallo/latex-makefile"
	@echo "  Copyright Alejandro Gallo GPLv3 $(MAKEFILE_DATE)"
	@echo ""

dnl vim: noexpandtab
