PREFIX   ?= /usr/bin
DIST     ?= dist
SRC      ?= src
BUILD    ?= build
BIN_NAME ?= Makefile
MAIN_BIN ?= $(DIST)/$(BIN_NAME)

README   ?= README.md

SOURCES  ?= $(wildcard $(SRC)/*)


.PHONY: clean test

.DEFAULT_TARGET = $(MAIN_BIN)

$(MAIN_BIN): $(SOURCES)
	@mkdir -p $(shell dirname $@)
	cp $< $@

doc: $(README)
$(README): $(SOURCES) README.md.in
	cat README.md.in > README.md
	./tools/doc.py >> README.md

clean:
	rm -rf dist build





test:
	@echo SOURCES = $(SOURCES)
