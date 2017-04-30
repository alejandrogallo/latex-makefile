set -x
cp ../../dist/Makefile .
set +x

TEST_DESCRIPTION="Simplest build directory test"
make_flags="--no-print-directory VIEW= QUIET=1 QQUIET=1"

eval "$(make ${make_flags} print-MAIN_SRC)"
eval "$(make ${make_flags} print-BUILD_DOCUMENT)"
eval "$(make ${make_flags} print-BUILD_DIR)"
eval "$(make ${make_flags} print-TOC_FILE)"
eval "$(make ${make_flags} print-TOC_DEP)"
eval "$(make ${make_flags} print-BIBITEM_FILES)"

echo "MAIN_SRC       = $MAIN_SRC"
echo "BUILD_DOCUMENT = $BUILD_DOCUMENT"
echo "BUILD_DIR      = $BUILD_DIR"
echo "TOC_FILE       = $TOC_FILE"
echo "TOC_DEP        = $TOC_DEP"
echo "BIBITEM_FILES  = $BIBITEM_FILES"

echo "Making..."
make ${make_flags}

echo "Build dir"
ls ${BUILD_DIR}

main=$(basename ${MAIN_SRC} .tex)

if [[ ! -f "${BUILD_DOCUMENT}" ]]; then
  echo "File BUILD_DOCUMENT = ${BUILD_DOCUMENT} not found !!"
  TEST_RESULT=1
elif [[ ! -f "${BUILD_DIR}/${BUILD_DOCUMENT}" ]]; then
  echo "File BUILD_DIR = ${BUILD_DIR}/${BUILD_DOCUMENT} not found !!"
  TEST_RESULT=1
elif [[ -f "${main}.aux" ]]; then
  echo "File main = ${main}.aux found !!"
  TEST_RESULT=1
elif [[ -f "${main}.log" ]]; then
  echo "File main = ${main}.log found !!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_DEP}" ]]; then
  echo "File TOC_DEP = ${TOC_DEP} not found !!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_FILE}" ]]; then
  echo "File TOC_FILE = ${TOC_FILE} not found !!"
  TEST_RESULT=1
elif [[ ! -f "${BIBITEM_FILES}" ]]; then
  echo "File BIBITEM_FILE = ${BIBITEM_FILES} not found !!"
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

