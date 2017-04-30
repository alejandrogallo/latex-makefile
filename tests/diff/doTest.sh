cp ../../dist/Makefile .
#set -x

TEST_DESCRIPTION="Check that latexdiff works with git commits"
make_flags="--no-print-directory VIEW= QUIET=1 QQUIET=1"

eval "$(make ${make_flags} print-MAIN_SRC)"
eval "$(make ${make_flags} print-DIFF_BUILD_DIR)"
eval "$(make ${make_flags} print-DIFF_SRC_NAME)"
eval "$(make ${make_flags} MAIN_SRC=${DIFF_BUILD_DIR}/${DIFF_SRC_NAME} print-TOC_FILE)"
eval "$(make ${make_flags} MAIN_SRC=${DIFF_BUILD_DIR}/${DIFF_SRC_NAME} print-TOC_DEP)"


git init

git config user.email "me@latex-makefile.com"
git config user.name "Test job"

git add .
git commit -m "Initial commit"

sed -i -e \
  "s/.*test-include.*/Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod/"  \
  -i -e \
  "s/sed/I do not like SED/g"  \
  ${MAIN_SRC}

cat ${MAIN_SRC}
git commit -am "Second commit"
git log | cat

make ${make_flags} diff

rm -rf .git
git checkout ${MAIN_SRC}





if [[ ! -f "${TOC_FILE}" ]]; then
  echo "${TOC_FILE} file not found!"
  TEST_RESULT=1
elif [[ ! -f "${DIFF_BUILD_DIR}/$(basename ${DIFF_SRC_NAME} .tex).pdf" ]]; then
  echo "$(basename ${DIFF_SRC_NAME} .tex).pdf file  not found!"
  TEST_RESULT=1
elif [[ ! -f "${DIFF_BUILD_DIR}/${DIFF_SRC_NAME}" ]]; then
  echo "${DIFF_BUILD_DIR}/${DIFF_SRC_NAME} file not found!"
  TEST_RESULT=1
elif [[ ! -d "${DIFF_BUILD_DIR}" ]]; then
  echo "${DIFF_BUILD_DIR} directory not found!"
  TEST_RESULT=1
elif [[ ! -f "${DIFF_SRC_NAME}" ]]; then
  echo "${DIFF_SRC_NAME} file  not found, this should not be the case!"
  TEST_RESULT=1
elif [[ ! -f "$(basename ${DIFF_SRC_NAME} .tex).pdf" ]]; then
  echo "$(basename ${DIFF_SRC_NAME} .tex).pdf file not found, this should not be the case!"
  TEST_RESULT=1
else
  TEST_RESULT=0
fi

echo "TEST_RESULT = ${TEST_RESULT}"

#vim-run: bash %
