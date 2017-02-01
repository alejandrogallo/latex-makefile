#cp ../../dist/Makefile .

TEST_DESCRIPTION="Check that latexdiff works with git commits"

eval $(make --no-print-directory print-TOC_FILE)
eval $(make --no-print-directory print-TOC_DEP)
eval $(make --no-print-directory print-MAIN_SRC)

git init
git add .
git commit -m "Initial commit"

cat >> ${MAIN_SRC}<<EOF
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren,
no sea takimata sanctus est Lorem ipsum dolor sit amet.

\\end{document}
EOF

git commit -am "Second commit"


make --no-print-directory QUIET=1 VIEW_PDF= diff

rm -rf .git
git checkout ${MAIN_SRC}

exit 0




if [[ ! -f "${TOC_DEP}" ]]; then
  echo "${TOC_DEP} file not found!"
  TEST_RESULT=1
elif [[ ! -f "${TOC_FILE}" ]]; then
  echo "${TOC_FILE} file not found!"
  TEST_RESULT=1
else
  TEST_RESULT=0
fi


#vim-run: bash %
