todo: $(TEXFILES) ## Print the todos from the main document
	$(ARROW) Parsing \\TODO{} in $(MAIN_SRC)
	$(DEBUG)$(SED) -n "/\\TODO{/,/}/\
	{\
		s/.TODO/===/; \
		s/[{]//g; \
		s/[}]/===/g; \
		p\
	}" $(TEXFILES)

dnl vim: noexpandtab
