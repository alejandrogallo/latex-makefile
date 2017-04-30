include_once(log.m4)dnl
include_once(shell-utils.m4)dnl
dnl
# If pythontex is being used
WITH_PYTHONTEX  ?=

PYTHONTEX  ?= pythontex

#FIXME: find a way of not having to compile the main document again
%.pytxcode: %.tex
	$(ARROW) "Compiling latex for pythontex"
	$(PDFLATEX) $<
	$(ARROW) "Creating pythontex"
	$(PYTHONTEX) $<

dnl vim: noexpandtab
