src_makefile=src/Makefile
dist_makefile=dist/Makefile

version=$(git describe --tags)
date=$(date +"%d-%m-%Y %H:%M")

DEBUG=
if [[ -n ${DEBUG} ]]; then
  echo ${version}
  echo ${date}
fi

sed "
s/\(^MAKEFILE_VERSION.*=\).*/\1 ${version}/
s/\(^MAKEFILE_DATE.*=\).*/\1 ${date}/
" ${src_makefile}

