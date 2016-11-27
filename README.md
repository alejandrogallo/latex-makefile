
# The ultimate TeX Makefile #

Bibliography generation
=======================

This generates a bbl file from a  bib file For documents without a bib
file, this  will also be  targeted, bit  the '-' before  the $(BIBTEX)
ensures that the whole building doesn't fail because of it

```bash 
make $(BIBITEM_FILE)
```
Reveal.js presentation
======================

This creates a revealjs presentation using the the pandoc program stored in
the make variable PANDOC.

```bash 
make revealjs
```
Presenter console generator
===========================

pdfpc is a nice program for presenting beamer presentations with notes
and a speaker clock. This target implements a simple script to convert
the standard \notes{ } beamer  command into pdfpc compatible files, so
that you can also see your beamer notes inside the pdfpc program.

```bash 
make pdf-presenter-console
```
Distribution
============

Create a distribution folder wit the bare minimum to compile your project.
For example it will consider the files in the DEPENDENCIES variable, so make
sure to update or add DEPENDENCIES to it in the config.mk per user
configuration.

```bash 
make dist
```
Check syntax
============

It checks the syntax (lints) of all the tex sources using the program in the
TEX_LINTER variable.

```bash 
make lint
```
Update the makefile from source
===============================

You can always get the  last latex-makefile version using this target.
You may override the GH_REPO_FILE to  any path where you save your own
personal makefile

```bash 
make update
```
Ctags generation for latex documents
====================================

Generate a tags  file so that you can navigate  through the tags using
compatible editors such as emacs or (n)vi(m).

```bash 
make tags
```
Print quick help
================

It prints a quick help in the terminal
```bash 
make help
```
