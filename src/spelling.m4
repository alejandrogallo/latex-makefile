SPELLER ?= aspell
SPELL_DIR ?= .spell
SPELL_LANG ?= en
CHECK_SPELL ?=

# ==============
# Check spelling
# ==============
#
# It checks the spelling of all the tex sources using the program in the
# SPELLER variable. The default value of the language is english, you can
# change it by setting in your `config.mk` file
# ```make
# SPELL_LANG = fr
# ```
# if you happen to write in french.
#
spelling: $(TEXFILES) ## Check spelling of latex sources
	$(ARROW) Checking the spelling in $(SPELL_LANG)
	$(DEBUG)mkdir -p $(SPELL_DIR)
	$(DEBUG)for file in $?; do \
		$(SPELLER) --home-dir=$(SPELL_DIR) \
		-l $(SPELL_LANG) -t -c $$file; \
	done

dnl vim: noexpandtab
