cp ../../dist/Makefile .
set -x

TEST_DESCRIPTION="Check that latexdiff works with git commits"

eval $(make --no-print-directory print-MAIN_SRC)
eval $(make --no-print-directory print-DIFF_BUILD_DIR)
eval $(make --no-print-directory print-DIFF_SRC_NAME)
eval $(make --no-print-directory MAIN_SRC=${DIFF_BUILD_DIR}/${DIFF_SRC_NAME} print-TOC_FILE)
eval $(make --no-print-directory MAIN_SRC=${DIFF_BUILD_DIR}/${DIFF_SRC_NAME} print-TOC_DEP)


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

make --no-print-directory diff

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
elif [[ -f "${DIFF_SRC_NAME}" ]]; then
  echo "${DIFF_BUILD_DIR} file  found, this should not be the case!"
  TEST_RESULT=1
elif [[ -f "$(basename ${DIFF_SRC_NAME} .tex).pdf" ]]; then
  echo "$(basename ${DIFF_SRC_NAME} .tex).pdf file  found, this should not be the case!"
  TEST_RESULT=1
else
  TEST_RESULT=0
fi


#vim-run: bash %
