cp ../../dist/Makefile .

TEST_DESCRIPTION="Simplest build directory test"

eval $(make --no-print-directory print-MAIN_SRC)
eval $(make --no-print-directory print-BUILD_DOCUMENT)
eval $(make --no-print-directory print-BUILD_DIR)


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
else
  TEST_RESULT=0
fi


