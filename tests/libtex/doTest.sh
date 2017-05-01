cp ../../dist/Makefile .

TEST_DESCRIPTION="Libtex should copy files correctly"
make_flags="--no-print-directory VIEW= QUIET=1 QQUIET=1 DEBUG="

# For some reason make detects that we are somewhere else from the test script
# sourcing and we have to add the --no-print-directory flag so that we can eval
# without the leaving directory message for sub-builds in make
eval "$(make ${make_flags} print-TOC_FILE)"
eval "$(make ${make_flags} print-TOC_DEP)"
TEXFILES=($(sed s/.*=// <<<"$(make QUIET=1 QQUIET=1 --no-print-directory print-TEXFILES)"))
PACKAGES_FILES_BUILD=($(sed s/.*=// <<<"$(make QUIET=1 QQUIET=1 --no-print-directory print-PACKAGES_FILES_BUILD)"))

echo "${TOC_FILE}"
echo "${TOC_DEP}"
echo "${TEXFILES[@]}"

make ${make_flags}

TEST_RESULT=0

if [[ -f "${TOC_DEP}" ]]; then
  echo "${TOC_DEP} file was found!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_FILE}" ]]; then
  echo "${TOC_FILE} file not found!"
  TEST_RESULT=1
elif [[ ! -f "main.pdf" ]]; then
  echo "main.pdf file not found!"
  TEST_RESULT=1
fi

for texfile in ${TEXFILES[@]} ; do
  if [[ ! -f "${texfile}" ]]; then
    echo "${texfile} was not found!!!"
    TEST_RESULT=1
  fi
done

for package in ${PACKAGES_FILES_BUILD[@]} ; do
  if [[ ! -f "${package}" ]]; then
    echo "${package} was not found!!!"
    TEST_RESULT=1
  fi
done

#vim-run: bash %
