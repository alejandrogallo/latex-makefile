# =============
# Main cleaning
# =============
#
# This does a main cleaning of the produced auxiliary files.  Before using it
# check which files are going to be cleaned up.
#
clean: ## Remove build and temporary files
	$(ARROW) Cleaning up...
	$(DEBUG){ for file in $(CLEAN_FILES); do echo "  *  $$file"; done }
	$(DEBUG)rm -rf $(CLEAN_FILES)
