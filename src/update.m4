# ===============================
# Update the makefile from source
# ===============================
#
# You can always get the  last `latex-makefile` version using this target.
# You may override the `GH_REPO_FILE` to  any path where you save your own
# personal makefile
#
update: ## Update the makefile from the repository
	$(ARROW) "Getting makefile from $(GH_REPO_FILE)"
	$(DEBUG)wget $(GH_REPO_FILE) -O Makefile
GH_REPO_FILE ?= https://raw.githubusercontent.com/alejandrogallo/latex-makefile/master/dist/Makefile