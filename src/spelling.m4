include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
# Speller program to use
SPELLER ?= aspell
# Directory to store spelling related information
SPELL_DIR ?= .spell
# Language for the spelling program
SPELL_LANG ?= en
# Wether or not spelling should be checked
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
# Wether to check spelling or not is controlled by the `CHECK_SPELL`
# variable, so if you want to check spelling set it to one
# ```make
# CHECK_SPELL = 1
# ```
# otherwise do not set it.
#
spelling: $(TEXFILES) ## Check spelling of latex sources
	$(ARROW) Checking the spelling in $(SPELL_LANG)
	$(DBG_FLAG)mkdir -p $(SPELL_DIR)
	$(DBG_FLAG)for file in $?; do \
		$(SPELLER) --home-dir=$(SPELL_DIR) \
		-l $(SPELL_LANG) -t -c $$file; \
	done

dnl vim:ft=make:noexpandtab:
