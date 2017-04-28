# If secondary programs output is shown
QUIET ?= 0

ifneq ($(strip $(QUIET)),0)
	FD_OUTPUT = 2>&1 > /dev/null
else
	FD_OUTPUT =
endif

# Print commands like [CMD]
define print-cmd-name
"[$(COLOR_LB) \
$(shell \
	if [[ "$(1)" =~ g++ ]]; then \
		echo -n GXX; \
	elif [[ "$(1)" =~ gcc ]]; then \
		echo -n GCC; \
	elif [[ "$(1)" =~ icc ]]; then \
		echo -n ICC; \
	elif [[ "$(1)" =~ cc ]]; then \
		echo -n CC; \
	elif [[ "$(1)" =~ python2 ]]; then \
		echo -n PY2; \
	elif [[ "$(1)" =~ python2 ]]; then \
		echo -n PY2; \
	elif [[ "$(1)" =~ python3 ]]; then \
		echo -n PY3; \
	elif [[ "$(1)" =~ pdflatex ]]; then \
		echo -n pdfTeX; \
	elif [[ "$(1)" =~ bash ]]; then \
		echo -n BSH; \
	elif [[ "$(1)" =~ asymptote ]]; then \
		echo -n ASY; \
	elif [[ "$(1)" =~ gnuplot ]]; then \
		echo -n GPT; \
	else \
		echo -n "$(1)" | tr a-z A-Z ; \
	fi
)\
$(COLOR_E)]"
endef

# If the main messages should be also muted
QQUIET     ?=
DEBUG      ?= @
# For coloring
TPUT       ?= $(shell $(WHICH) tput 2> /dev/null)
# If messages should have color
WITH_COLOR ?= 1


ifndef QQUIET

ifeq ($(strip $(WITH_COLOR)),1)
COLOR_R         ?= $(if $(TPUT),$(shell $(TPUT) setaf 1),"\033[0;31m")
COLOR_G         ?= $(if $(TPUT),$(shell $(TPUT) setaf 2),"\033[0;32m")
COLOR_Y         ?= $(if $(TPUT),$(shell $(TPUT) setaf 3),"\033[0;33m")
COLOR_DB        ?= $(if $(TPUT),$(shell $(TPUT) setaf 4),"\033[0;34m")
COLOR_L         ?= $(if $(TPUT),$(shell $(TPUT) setaf 5),"\033[0;35m")
COLOR_LB        ?= $(if $(TPUT),$(shell $(TPUT) setaf 6),"\033[0;36m")
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
