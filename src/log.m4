# If the main messages should be also muted
QQUIET     ?=
DEBUG      ?= @
# For coloring
TPUT       ?= $(shell $(WHICH) tput 2> /dev/null)
# If messages should have color
WITH_COLOR ?= 1


ifndef QQUIET

ifeq ($(strip $(WITH_COLOR)),1)
COLOR_B         ?= $(if $(TPUT),$(shell $(TPUT) setaf 5),"\033[0;35m")
COLOR_E         ?= $(if $(TPUT),$(shell $(TPUT) sgr0),"\033[0m")
ARROW           ?= @echo "$(COLOR_B)===>$(COLOR_E)"
else
ARROW           ?= @echo "===>"
endif #WITH_COLOR

ECHO            ?= @echo

else
ARROW           := @ > /dev/null echo
ECHO            := @ > /dev/null echo
endif #QQUIET
