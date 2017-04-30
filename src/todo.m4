include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
todo: $(TEXFILES) ## Print the todos from the main document
	$(ARROW) Parsing \\TODO{} in $(MAIN_SRC)
	$(DBG_FLAG)$(SED) -n "/\\TODO{/,/}/\
	{\
		s/.TODO/===/; \
		s/[{]//g; \
		s/[}]/===/g; \
		p\
	}" $(TEXFILES)

dnl vim: noexpandtab
