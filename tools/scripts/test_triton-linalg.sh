#!/bin/bash

function check_ret(){
  if [ $1 -ne 0 ]; then exit 1; fi
}

function test_linalg_unittest() {
  mkdir -p ${TRITON_LINALG_WORK_DIR}/test_logs
  export TRITON_PLUGIN_DIRS=${TRITON_LINALG_WORK_DIR}/triton-linalg
  pip3 install lit
  pushd ${TRITON_LINALG_WORK_DIR}/triton-linalg/triton/python/build/cmake.linux-x86_64-cpython-3.10/third_party/triton_linalg
    if lit test \
        --xunit-xml-output ${TRITON_LINALG_WORK_DIR}/test_logs/test_linalg_unittest_results.xml;
    then
      error=0
    else
      error=1
    fi
  popd  
  check_ret ${error}
}

function print_usage() {
  RED='\033[0;31m'
  BLUE='\033[0;34m'
  BOLD='\033[1m'
  NONE='\033[0m'

  echo -e "${BOLD}bash ci_daily.sh${NONE} Command [Options]"

  echo -e "\n${RED}Command${NONE}:

  ${BLUE}test_linalg_unittest${NONE}: Run tests

  ${BLUE}usage${NONE}: display this message
  "
}

# main entry
function main() {
  if [ -z "${TRITON_LINALG_WORK_DIR}" ]; then
    TRITON_LINALG_WORK_DIR=${CI_WORK_DIR}
  fi
  local cmd=$1
  N_JOBS=""
  if [ ! -z "$2" ]; then
    N_JOBS=$2
  fi
  case $cmd in
    test_linalg_unittest)
      test_linalg_unittest
      ;;
    usage)
      print_usage
      ;;
    *)
      print_usage
      ;;
  esac
}

main $@

