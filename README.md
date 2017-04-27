
[![Build Status](https://travis-ci.org/alejandrogallo/latex-makefile.svg?branch=master)](https://travis-ci.org/alejandrogallo/latex-makefile)

# The ultimate TeX Makefile #

## Quick start ##

Just drop the Makefile in your project directory and hit make.  The makefile
should recognise the main document automatically by looking for a
`\begin{document}` in the `tex` file of the current directory.

The main idea of the makefile is not to modify it directly, but rather through
a `make` configuration file `config.mk`. There you can set many important
variables for the project, like the verbosity `QUIET=1` and many more.


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

