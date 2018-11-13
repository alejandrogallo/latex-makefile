include_once(common-makefile/src/log.m4)dnl
include_once(common-makefile/src/shell-utils.m4)dnl
dnl
# This is used for printing defined variables from Some other scripts. For
# instance if you want to know the value of the PDF_VIEWER defined in the
# Makefile, then you would do
#    make print-PDF_VIEWER
# and this would output PDF_VIEWER=mupdf for instance.
FORCE:
print-%:
	$(DBG_FLAG)echo '$*=$($*)'

# =====================================
# Print a variable used by the Makefile
# =====================================
#
# For debugging purposes it is useful to print out some variables that the
# makefile is using, for that just type `make print` and you will be prompted
# to insert the name of the variable that you want to know.
#
FORCE:
print: ## Print a variable
	$(DBG_FLAG)read -p "Variable to print: " variable && \
		$(MAKE) --no-print-directory print-$$variable

