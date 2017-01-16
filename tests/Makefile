
DIST_MAKEFILE = ../dist/Makefile

TESTS = $(wildcard **/doTest.sh)

.PHONY: all $(DIST_MAKEFILE)

all: $(DIST_MAKEFILEk)
	./testazo.sh

$(DIST_MAKEFILE):
	make -C ../ dist/Makefile

clean:
	for test in $(TESTS); do\
		make -C $$(dirname $$test ) clean;\
		rm $$(dirname $$test)/test.out;\
	done

# This is used for printing defined variables from Some other scripts. For
# instance if you want to know the value of the PDF_VIEWER defined in the
# Makefile, then you would do
#    make print-PDF_VIEWER
# and this would output PDF_VIEWER=mupdf for instance.
FORCE:
print-%:
	@echo '$*=$($*)'
