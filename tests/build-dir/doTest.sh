cp ../../dist/Makefile .

TEST_DESCRIPTION="Simplest build directory test"

eval $(make --no-print-directory print-MAIN_SRC)
eval $(make --no-print-directory print-BUILD_DOCUMENT)
eval $(make --no-print-directory print-BUILD_DIR)
eval $(make --no-print-directory print-TOC_FILE)
eval $(make --no-print-directory print-TOC_DEP)

echo "${TOC_FILE}"
echo "${TOC_DEP}"


make --no-print-directory QUIET=1 VIEW_PDF=

main=$(basename ${MAIN_SRC} .tex)

if [[ ! -f "${BUILD_DOCUMENT}" ]]; then
  TEST_RESULT=1
elif [[ -f "${BUILD_DIR}/${BUILD_DOCUMENT}" ]]; then
  TEST_RESULT=1
elif [[ -f "${main}.aux" ]]; then
  TEST_RESULT=1
elif [[ -f "${main}.log" ]]; then
  TEST_RESULT=1
elif [[ ! -f "${TOC_DEP}" ]]; then
  echo "${TOC_DEP} file not found!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_FILE}" ]]; then
  echo "${TOC_FILE} file not found!"
  TEST_RESULT=1
else
  TEST_RESULT=0
fi


