include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
RELEASES_DIR=releases
RELEASES_FMT=tar
releases: $(BUILD_DOCUMENT) ## Create all releases (according to tags)
	$(ARROW) Copying releases to $(RELEASES_DIR) folder in $(RELEASES_FMT) format
	$(DBG_FLAG)mkdir -p $(RELEASES_DIR)
	$(DBG_FLAG)for tag in $$($(GIT) tag); do\
		echo "Processing $$tag"; \
		$(GIT) archive --format=$(RELEASES_FMT) \
		--prefix=$$tag/ $$tag > $(RELEASES_DIR)/$$tag.$(RELEASES_FMT); \
	done

dnl vim: noexpandtab
