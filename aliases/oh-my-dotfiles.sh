#!/usr/bin/env sh

if ! (type setvar &> /dev/null); then
  setvar() {
    local _variable_to_be_set="$1"
    local _value_to_be_set="$2"

    if [[ $# -gt 2 ]]; then
      echo "$0: too many arguments"
      return 2
    fi

    if [[ -n "$_variable_to_be_set" ]]; then
      eval $_variable_to_be_set="$_value_to_be_set"
    fi
  }
fi

if ! (type __omd::execute &> /dev/null); then
  __omd::execute() {
    local _cmd=$1
    local _verbose=${2:-${OMD_VERBOSE:-false}}

    if $_verbose; then
      echo "-----"
      echo $_cmd
      echo "-----"
    fi

    eval $_cmd
  }
fi

#cmd = "ls /"
#__omd::execute($cmd, true)

#echo "foo"
