include_once(os.m4)dnl
dnl
# Shell used
SH         ?= bash
# Alias for `SHELL'
SHELL      ?= $(SH)
# Python interpreter
PY         ?= python
# Alias for `PY'
PYTHON     ?= $(PY)
# Grep program version
GREP       ?= grep
# Find utility
FIND       ?= find
# `sed` program version
SED        ?= $(if $(OSX),gsed,sed)
# `awk` program to use
AWK        ?= $(if $(OSX),gawk,awk)
# For creating tags
CTAGS      ?= ctags
# To get complete paths
READLINK   ?= $(if $(OSX),greadlink,readlink)
# `xargs` program to use
XARGS      ?= xargs
# `tr` program to use
TR         ?= tr
# `git` version to use
GIT        ?= git
# `which` program to use
WHICH      ?= which
# `sort` program to use
SORT       ?= sort
# `uniq` program to use
UNIQ       ?= uniq
