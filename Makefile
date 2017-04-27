PREFIX   ?= /usr/bin
DIST     ?= dist
SRC      ?= src
BUILD    ?= build
BIN_NAME ?= Makefile
MAIN_BIN ?= $(DIST)/$(BIN_NAME)

README   ?= README.md

SOURCES  ?= $(wildcard $(SRC)/*)


.PHONY: clean test

.DEFAULT_TARGET = all

all: $(MAIN_BIN) doc

$(MAIN_BIN): $(SOURCES)
	@mkdir -p $(shell dirname $@)
	(cd $(SRC) && m4 Makefile) > dist/Makefile

doc: $(README) $(MAIN_BIN)
$(README): $(SOURCES) README.md.in
	cat README.md.in > README.md
	./tools/doc.py >> README.md

clean:
	rm -rf dist build
	make -C tests clean





test: $(MAIN_BIN)
	make -C tests/

# vim: cc=80
