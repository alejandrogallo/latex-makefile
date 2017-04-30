cp ../../dist/Makefile .

TEST_DESCRIPTION="\\tableofcontents means toc file and toc deps file exist"
make_flags="--no-print-directory VIEW= QUIET=1 QQUIET=1"

# For some reason make detects that we are somewhere else from the test script
# sourcing and we have to add the --no-print-directory flag so that we can eval
# without the leaving directory message for sub-builds in make
eval "$(make ${make_flags} print-TOC_FILE)"
eval "$(make ${make_flags} print-TOC_DEP)"

echo "${TOC_FILE}"
echo "${TOC_DEP}"

make ${make_flags}

if [[ ! -f "${TOC_DEP}" ]]; then
  echo "${TOC_DEP} file not found!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_FILE}" ]]; then
  echo "${TOC_FILE} file not found!"
  TEST_RESULT=1
elif [[ ! -f "images/test.pdf" ]]; then
  echo "images/test.pdf file not found!"
  TEST_RESULT=1
else
  TEST_RESULT=0
fi


#vim-run: bash %
