
[![Build Status](https://travis-ci.org/alejandrogallo/latex-makefile.svg?branch=master)](https://travis-ci.org/alejandrogallo/latex-makefile)

# The ultimate TeX Makefile #

## Quick start ##

Just drop the Makefile in your project directory and hit make.  The makefile
should recognise the main document automatically by looking for a
`\begin{document}` in the `tex` file of the current directory.


## Features overview ##


  * Build in a different directory.
  * Multi bibtex files.
  * Automatic handling of the table of contents (smart recompilation).
  * Automatic handling of [bibtex](http://www.bibtex.org/) (smart recompilation).
  * Import `.sty` files (latex packages) from custom directory.
  * Distribution making for sending documents to the publisher.
  * Automatic recognition of included graphics.
    - Automatic [asymptote](http://asymptote.sourceforge.net/) compilation.
    - Automatic [gnuplot](http://www.gnuplot.info/) compilation.
    - Automatic `python` figures compilation.

Force compilation
=================

This makefile only compiles the TeX document if it is strictly necessary, so
sometimes to force compilation this target comes in handy.

```bash 
make force
```
Bibliography generation
=======================

This generates a `bbl` file from a  `bib` file For documents without a `bib`
file, this  will also be  targeted, bit  the '-' before  the `$(BIBTEX)`
ensures that the whole building doesn't fail because of it

```bash 
make $(BIBITEM_FILE)
```
View document
=============

Open and refresh pdf.

```bash 
make view-pdf
```
Open pdf viewer
===============

Open a viewer if there is none open viewing `$(BUILD_DOCUMENT)`

```bash 
make open-pdf
```
Refresh mupdf
=============

If the opened document is being viewed with `mupdf` this target uses the
mupdf signal API to refresh the document.

```bash 
make $(FIGS_SUFFIXES)
```
Main cleaning
=============

This does a main cleaning of the produced auxiliary files.  Before using it
check which files are going to be cleaned up.

```bash 
make clean
```
Reveal.js presentation
======================

This creates a revealjs presentation using the the pandoc program stored in
the make variable PANDOC.

```bash 
make revealjs
```
Unix man document
=================

This creates a man page using `pandoc`.

```bash 
make man
```
HTML document
=============

This creates an html page using `pandoc`.

```bash 
make html
```
Presenter console generator
===========================

`pdfpc` is a nice program for presenting beamer presentations with notes
and a speaker clock. This target implements a simple script to convert
the standard `\notes{ }` beamer  command into `pdfpc` compatible files, so
that you can also see your beamer notes inside the `pdfpc` program.

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
Diff
====

This target creates differences between older versions of the main latex file
by means of [GIT](https://git-scm.com/). You have to specify the commits that
you want to compare by doing

```bash
make DIFF="HEAD HEAD~3" diff
```
If you want to compare the HEAD commit with the commit three times older than
HEAD. You can also provide a *commit hash*. The default value is `HEAD HEAD~1`.

The target creates a distribution folder located in the variable
DIFF_BUILD_DIR. *Warning*: It only works for single document tex projects.
```bash 
make diff
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

You can always get the  last `latex-makefile` version using this target.
You may override the `GH_REPO_FILE` to  any path where you save your own
personal makefile

```bash 
make https
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
