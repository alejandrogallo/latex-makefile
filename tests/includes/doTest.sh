cp ../../dist/Makefile .

TEST_DESCRIPTION="Test if includes are being parsed correctly"

# For some reason make detects that we are somewhere else from the test script
# sourcing and we have to add the --no-print-directory flag so that we can eval
# without the leaving directory message for sub-builds in make
eval "$(make QUIET=1 QQUIET=1 --no-print-directory print-TOC_FILE)"
eval "$(make QUIET=1 QQUIET=1 --no-print-directory print-TOC_DEP)"
TEXFILES=($(sed s/.*=// <<<"$(make QUIET=1 QQUIET=1 --no-print-directory print-TEXFILES)"))
TEXFILES_GOOD=(
file.tex
includes/hello_world.tex
includes/hello_world_2.tex
)

echo "${TOC_FILE}"
echo "${TOC_DEP}"
echo "${TEXFILES[@]}"

make --no-print-directory QUIET=1 VIEW=

if [[ ! -f "${TOC_DEP}" ]]; then
  echo "${TOC_DEP} file not found!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_FILE}" ]]; then
  echo "${TOC_FILE} file not found!"
  TEST_RESULT=1
elif [[ ! -f "images/test.pdf" ]]; then
  echo "images/test.pdf file not found!"
  TEST_RESULT=1
elif [[ ! -f "file.pdf" ]]; then
  echo "file.pdf file not found!"
  TEST_RESULT=1
else
  TEST_RESULT=0
fi

for texfile in ${TEXFILES[@]} ; do
  if [[ ! -f "${texfile}" ]]; then
    echo "${texfile} was parsed incorrectly!!!!"
    TEST_RESULT=1
  fi
done


#vim-run: bash %
