include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
# ===========================
# Presenter console generator
# ===========================
#
# `pdfpc` is a nice program for presenting beamer presentations with notes
# and a speaker clock. This target implements a simple script to convert
# the standard `\notes{ }` beamer  command into `pdfpc` compatible files, so
# that you can also see your beamer notes inside the `pdfpc` program.
#
pdf-presenter-console: $(PDFPC_FILE) ## Create annotations file for the pdfpc program
$(PDFPC_FILE): $(TEXFILES)
	echo "[file]" > $@
	echo "$(PDF_DOCUMENT)" >> $@
	echo "[notes]" >> $@
	cat $(MAIN_SRC) | $(AWK) '\
		BEGIN { frame = 0; initialized = 0; } \
		/(\\begin{frame}|\\frame{)/ { \
			if(!/[%]/) { \
				frame++; print "###",frame \
			} \
		} \
		/\\note{/,/^\s*}\s*$$/ { \
			if(!/\\note{/ && !/^[ ]*}[ ]*$$/) {\
				if (frame == 0 && initialized == 0){ \
					frame++; \
					print "###",frame; \
					initialized = 1; \
				} \
				print $$0 ; \
			}\
		} \
		END { print frame } \
	' | tee -a $@

dnl vim: noexpandtab
