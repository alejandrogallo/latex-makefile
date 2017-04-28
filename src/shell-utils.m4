# Shell used
SH         ?= bash
# Python interpreter
PY         ?= python
# Grep program version
GREP       ?= grep
# Find utility
FIND       ?= find
# sed program version
SED        ?= $(if $(OSX),gsed,sed)
AWK        ?= $(if $(OSX),gawk,awk)
# For creating tags
CTAGS      ?= ctags
# To get complete paths
READLINK   ?= $(if $(OSX),greadlink,readlink)
XARGS      ?= xargs
TR         ?= tr
GIT        ?= git
WHICH      ?= which
SORT       ?= sort
UNIQ       ?= uniq
