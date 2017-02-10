cp ../../dist/Makefile .

TEST_DESCRIPTION="Simplest build directory test"

eval $(make --no-print-directory print-MAIN_SRC)
eval $(make --no-print-directory print-BUILD_DOCUMENT)
eval $(make --no-print-directory print-BUILD_DIR)
eval $(make --no-print-directory print-TOC_FILE)
eval $(make --no-print-directory print-TOC_DEP)
eval $(make --no-print-directory print-BIBITEM_FILE)

echo "${TOC_FILE}"
echo "${TOC_DEP}"


make --no-print-directory QUIET=1 VIEW=

main=$(basename ${MAIN_SRC} .tex)

if [[ ! -f "${BUILD_DOCUMENT}" ]]; then
  echo "File ${BUILD_DOCUMENT} not found !!"
  TEST_RESULT=1
elif [[ ! -f "${BUILD_DIR}/${BUILD_DOCUMENT}" ]]; then
  echo "File ${BUILD_DIR}/${BUILD_DOCUMENT} not found !!"
  TEST_RESULT=1
elif [[ -f "${main}.aux" ]]; then
  echo "File ${main}.aux found !!"
  TEST_RESULT=1
elif [[ -f "${main}.log" ]]; then
  echo "File ${main}.log found !!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_DEP}" ]]; then
  echo "File ${TOC_DEP} not found !!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_FILE}" ]]; then
  echo "File ${TOC_FILE} not found !!"
  TEST_RESULT=1
elif [[ ! -f "${BIBITEM_FILE}" ]]; then
  echo "File ${BIBITEM_FILE} not found !!"
  TEST_RESULT=1
elif [[ ! -f "images/test.pdf" ]]; then
  echo "File images/test.pdf not found !!"
  TEST_RESULT=1
elif [[ ! -f "images/transitions.pdf" ]]; then
  echo "File images/transitions.pdf not found !!"
  TEST_RESULT=1
else
  TEST_RESULT=0
fi


echo TEST_RESULT = ${TEST_RESULT}
