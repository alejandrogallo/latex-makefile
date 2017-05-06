# Name of the merged file
MERGE_FILE = merged.tex

# =====
# Merge
# =====
#
# Merge all include files into one single tex file
#
merge: $(MERGE_FILE) ## Create a merged file
$(MERGE_FILE): $(TEXFILES)
	$(ECHO) $(call print-cmd-name,CP) $@
	$(DBG_FLAG)cp $(MAIN_SRC) $@
	$(ECHO) $(call print-cmd-name,m4) $(@)
	$(DBG_FLAG)$(FD_OUTPUT)for texfile in $(TEXFILES); do\
			cat $@ | \
			$(removeTexComments) | \
			$(SED) "s/[\\]in\(put\|clude\)\s*{\(.*\)}/`include'(\2)/" | \
			m4 | tee $@; \
		done

# Directory for merged distribution
MERGE_DIST_DIR = merged_$(DIST_DIR)

# ===================
# Merged distribution
# ===================
#
# Create a distribution with only a tex file
#
merge-dist: merge ## Create a merged file distribution
	$(DBG_FLAG)$(MAKE) --no-print-directory \
		dist MAIN_SRC=$(MERGE_FILE) DIST_DIR=$(MERGE_DIST_DIR)

