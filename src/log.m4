include_once(shell-utils.m4)dnl
dnl
dnl
dnl
# If secondary programs output is shown
QUIET ?= 0
# If the log messages should be also muted
QQUIET     ?=
# If the commands issued should be printed write `DEBUG=1` if you want to see
# all commands.
DEBUG      ?=
# For coloring
TPUT       ?= $(shell $(WHICH) tput 2> /dev/null)
# If messages should have color
WITH_COLOR ?= 1

ifneq ($(strip $(QUIET)),0)
	FD_OUTPUT = 2>&1 > /dev/null
else
	FD_OUTPUT =
endif

ifdef DEBUG
DBG_FLAG =
DBG_FILE ?= .tex_dbg
$(shell date | $(SED) "p; s/./=/g" > $(DBG_FILE))
else
DBG_FLAG = @
DBG_FILE =
endif

define log-debug
>> $(or $(DBG_FILE),/dev/null) echo
endef

# Print commands like [CMD]
define print-cmd-name
"[$(COLOR_LB) \
$(shell \
	if test "$(1)" = g++; then \
		echo -n GXX; \
	elif test "$(1)" = gcc; then \
		echo -n GCC; \
	elif test "$(1)" = icc; then \
		echo -n ICC; \
	elif test "$(1)" = cc; then \
		echo -n CC; \
	elif test "$(1)" = povray; then \
		echo -n POV; \
	elif test "$(1)" = perl; then \
		echo -n PL; \
	elif test "$(1)" = perl5; then \
		echo -n PL5; \
	elif test "$(1)" = ruby; then \
		echo -n RB; \
	elif test "$(1)" = ruby2; then \
		echo -n RB2; \
	elif test "$(1)" = python; then \
		echo -n PY; \
	elif test "$(1)" = python2; then \
		echo -n PY2; \
	elif test "$(1)" = python3; then \
		echo -n PY3; \
	elif test "$(1)" = pdflatex; then \
		echo -n pdfTeX; \
	elif test "$(1)" = bash; then \
		echo -n BASH; \
	elif test "$(1)" = gnuplot; then \
		echo -n GPT; \
	elif test "$(1)" = mupdf; then \
		echo -n muPDF; \
	else \
		echo -n "$(1)" | tr a-z A-Z ; \
	fi
)\
$(COLOR_E)]"
endef

ifndef QQUIET

ifeq ($(strip $(WITH_COLOR)),1)
# Red
COLOR_R         ?= $(if $(TPUT),$(shell $(TPUT) setaf 1),"\033[0;31m")
# Green
COLOR_G         ?= $(if $(TPUT),$(shell $(TPUT) setaf 2),"\033[0;32m")
# Yellow
COLOR_Y         ?= $(if $(TPUT),$(shell $(TPUT) setaf 3),"\033[0;33m")
# Dark blue
COLOR_DB        ?= $(if $(TPUT),$(shell $(TPUT) setaf 4),"\033[0;34m")
# Lila
COLOR_L         ?= $(if $(TPUT),$(shell $(TPUT) setaf 5),"\033[0;35m")
# Light blue
COLOR_LB        ?= $(if $(TPUT),$(shell $(TPUT) setaf 6),"\033[0;36m")
# Empty color
COLOR_E         ?= $(if $(TPUT),$(shell $(TPUT) sgr0),"\033[0m")
ARROW           ?= @echo "$(COLOR_L)===>$(COLOR_E)"
else
ARROW           ?= @echo "===>"
endif #WITH_COLOR

ECHO            ?= @echo

else
ARROW           := @ > /dev/null echo
ECHO            := @ > /dev/null echo
endif #QQUIET

dnl vim: noexpandtab
