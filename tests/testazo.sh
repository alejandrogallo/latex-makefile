#! /usr/bin/env bash

#set -x

include() { source $@; }

# main logging functions
function header()   { echo -e "$(tput bold)\n$@$(tput sgr0)"; }
function success()  { echo -e "$(tput setaf 2) ==> $(tput sgr0) $@"; }
function error()    { echo -e "$(tput setaf 1) X $(tput sgr0) $@"; }
function arrow()    { echo -e "$(tput setaf 4) ==> $(tput sgr0) $@"; }

# READONLY PARAMETERS
declare -r TEST_OUT_FILE=test.out
declare -r TEST_NAME=doTest.sh
declare -r MAIN_TEST_FOLDER=$(dirname $(readlink -f $0))
declare -r CLASS_MAGIC_WORD="@CLASS"
declare -r ALL_CLASS=all
declare -r GH_DIST="https://raw.githubusercontent.com/alejandrogallo/testazo/master/dist/testazo.sh"

# GLOBAL VARIABLES
TEST_RESULT=1
FAILED_TEST_COUNT=0
FAILED_TEST_LIST=()
ALL_SCRIPTS=()

# DEFAULT FLAG VALUES
TEST_CLASS=all
LOCAL_CONFIG=${MAIN_TEST_FOLDER}/testconfig.sh
TEST_DEBUG=

# SCRIPT PARAMETERS
declare -r __SCRIPT_VERSION="0.5"
declare -r __SCRIPT_NAME=$( basename $0 )
declare -r __DESCRIPTION="Versatile test runner"
declare -r __OPTIONS=":hvt:ld"

update() {
  wget "${GH_DIST}" -O "${MAIN_TEST_FOLDER}/${__SCRIPT_NAME}"
  return $?
}

echo_debug() {
  [[ -n ${TEST_DEBUG} ]] || return 0
  if [[ -z $1 ]]; then
    # read from stdin
    while read line ; do
      echo "[DEBUG] >> $line" >&2
    done
  else
    # read from arguments
    echo "[DEBUG] >> $@" >&2
  fi
}

check_class() {
  local testScript=$1
  for className in $(get_classes ${testScript} | tr "," "\n"); do
    if [[ ${className} = ${TEST_CLASS} ]]; then
      return 0
    fi
  done
  return 1
}

get_classes() {
  local testScript=$1
  echo ${ALL_CLASS},$(grep "${CLASS_MAGIC_WORD}" ${testScript} | sed "s/.*${CLASS_MAGIC_WORD}=//")
}

get_description() {
  local testScript=$1
  grep -E "TEST_DESCRIPTION\s*=\s*" ${testScript} | sed "s/.*TEST_DESCRIPTION\s*=\s*//" | tr -d "\""
}

print_long_description() {
  local testScript=$1
  if grep LONG_TEST_DESCRIPTION ${testScript} 1>&2 > /dev/null; then
    echo ""
    sed -n "/cat.*LONG_TEST_DESCRIPTION/,/^LONG_TEST_DESCRIPTION/ { /LONG_TEST_DESCRIPTION/!p } " ${testScript}
    echo ""
  fi
}

filter_scripts() {
  local filteredScripts=()
  local testScript
  for testScript in ${ALL_SCRIPTS[@]} ; do
    if check_class ${testScript}; then
      filteredScripts=(${filteredScripts[@]} ${testScript})
    fi
  done
  ALL_SCRIPTS=(${filteredScripts[@]})
}

list_tests() {
  local testScript
  local testClasses
  local testDescription
  for testScript in ${ALL_SCRIPTS[@]} ; do
    header ${testScript#$MAIN_TEST_FOLDER/}
    testClasses=$(get_classes ${testScript})
    testDescription=$(get_description ${testScript})
    [[ -n ${testDescription} ]] && arrow "Description: ${testDescription}" || error "Description: No description available..."
    print_long_description ${testScript}
    arrow "Classes:  ${testClasses}"
  done
}

run_testScript() {
  local testScript
  local testFolder
  local testName
  local testDescription
  testScript=$1
  testFolder=$(dirname ${testScript})
  testName=$(basename ${testScript})
  testDescription=$(get_description ${testScript})
  TEST_RESULT=1
  header "Testing ${testName} ... "
  arrow "${testDescription}"
  print_long_description ${testScript}
  cd ${testFolder}
  if [[ -x ${testName} ]]; then
    ./${testName} > ${TEST_OUT_FILE}
    TEST_RESULT=$?
  else
    source ${testName} > ${TEST_OUT_FILE}
  fi
  if [[ ${TEST_RESULT} = 0 ]]; then
    success "Sucess"
  else
    error "Test FAILED"
    FAILED_TEST_LIST[${FAILED_TEST_COUNT}]=${testScript}
    let FAILED_TEST_COUNT+=1
  fi
  cd ${MAIN_TEST_FOLDER}
}


usage_head() { echo "Usage :  $__SCRIPT_NAME [-h|-help] [-v|-version] [-c CLASS_NAME] [-d] [-l] ... <test files>"; }
usage()
{
cat <<EOF
$(usage_head)

    $__DESCRIPTION

    Options:
      -h|help       Display this message
      -v|version    Display script version
      -l            List available test scripts for a given test class.
      -d            Enable debug messages
      -t            Test class (e.g. all essential extended)
                    Default: ${TEST_CLASS}

    Examples:

      List all tests:
        ./${__SCRIPT_NAME} -l -t all

      List default tests (${TEST_CLASS}):
        ./${__SCRIPT_NAME} -l

      Run tests with class "silicon"
        ./${__SCRIPT_NAME} -t silicon

      Run test files given by path using icc configuration
        ./${__SCRIPT_NAME} path/to/custom/testScript.sh path/to/other/doTest.sh

EOF
}    # ----------  end of usage  ----------

if [[ $1 == update ]]; then
  arrow "Updating from ${GH_DIST}"
  update
  exit $?
fi

while getopts $__OPTIONS opt
do
  case $opt in

  h|help     )  usage; exit 0   ;;

  v|version  )  echo "$__SCRIPT_NAME -- Version $__SCRIPT_VERSION"; exit 0   ;;

  l  ) LIST_TESTS=TRUE  ;;

  d  ) TEST_DEBUG=TRUE ;;

  t  ) TEST_CLASS=${OPTARG} ;;

  * )  echo -e "\n  Option does not exist : $OPTARG\n"
      usage_head; exit 1   ;;

  esac    # --- end of case ---
done
shift $(($OPTIND-1))

# Check if some input was given after flag parsing
# if so, consider them to be the scripts to be run
if [[ -n $@ ]]; then
  ALL_SCRIPTS=($@)
else
  ALL_SCRIPTS=($(find ${MAIN_TEST_FOLDER} -name ${TEST_NAME}))
  ALL_SCRIPTS=(${ALL_SCRIPTS[@]} $(find ${MAIN_TEST_FOLDER} -name "test_*" ))
  # Filter scripts by classes
  filter_scripts
fi

# list scripts
if [[ ${LIST_TESTS} = TRUE ]]; then
  header "${#ALL_SCRIPTS[@]} tests with class ${TEST_CLASS}"
  list_tests
  exit 0
fi

#Title
header "${__DESCRIPTION} version ${__SCRIPT_VERSION}"
# Print out all relevant configuration
arrow "TEST_CLASS  = ${TEST_CLASS}"

if [[ -n ${TEST_DEBUG} ]]; then
  header "Debug information"
  arrow "TEST_OUT_FILE    = ${TEST_OUT_FILE}"
  arrow "TEST_NAME        = ${TEST_NAME}"
  arrow "MAIN_TEST_FOLDER = ${MAIN_TEST_FOLDER}"
  arrow "CLASS_MAGIC_WORD = ${CLASS_MAGIC_WORD}"
  arrow "ALL_CLASS        = ${ALL_CLASS}"
fi

arrow "Sourcing ${LOCAL_CONFIG} file"
[[ -f ${LOCAL_CONFIG} ]] && source ${LOCAL_CONFIG}

# run the tests
for TEST_SCRIPT in ${ALL_SCRIPTS[@]}; do
  run_testScript ${TEST_SCRIPT};
done

header "${#ALL_SCRIPTS[@]} tests DONE for class '${TEST_CLASS}'"
header "${FAILED_TEST_COUNT} tests FAILED for class '${TEST_CLASS}'"

#Print out the tests that failed, if any
if [[ ! ${#FAILED_TEST_LIST[@]} = 0 ]]; then
  error "Tests failed:"
  for TEST_SCRIPT in ${FAILED_TEST_LIST[@]} ; do
    echo -e "\t${TEST_SCRIPT}"
  done
else
  success "All tests passed!"
fi

if [[ ${FAILED_TEST_COUNT} != 0 && ${TEST_CLASS} == "essential" ]]; then
  cat <<EOF

############################################
#                                          #
#  DO NOT COMMIT TO MASTER BRANCH, PLEASE  #
#                                          #
############################################

EOF
fi

if [[ ! ${#FAILED_TEST_LIST[@]} = 0 ]]; then
  exit 1
fi
