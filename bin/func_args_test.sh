#!/usr/bin/env bash

set -euo pipefail

# Explanation of Different Argument Capture Methods:
#  - $*: Expands to a single string with all arguments concatenated (losing separation).
#  - $@: Expands arguments but behaves differently when quoted.
#  - "*": Expands as a single string.
#  - "$@": Expands each argument as a separate string (ideal for arrays).
#  - ("$*"): Stores all arguments as a single element in an array.
#  - ("$@"): Stores each argument as a separate element in an array (correct choice for preserving argument structure).

func() {
  #local __args=$*
  #local __args=$@
  #local __args="$*"
  #local __args="$@"
  #local __args=("$*")
  local __args=("$@")

  echo "Number of arguments: ${#__args[@]}"

  for arg in "${__args[@]}";
  do
    echo "Argument: $arg"
  done
}

func "one two" three four
