#!/usr/bin/env bash

# The -e flag makes sure the script exits as soon as one command returns a non-zero exit code
set -e

# Check that the required arguments are provided
check_variable () {
  if [ -z "${1+x}" ]; then
      echo "Variable $1 should be set"
      exit 1
  fi
}

if [ -n "$BENCH_DEBUG" ]
then
   echo "DEBUG: ocaml -version = $(ocaml -version)"
   echo "DEBUG: TRAVIS_COMMIT = $TRAVIS_COMMIT"
fi

git checkout -q "$TRAVIS_COMMIT"

# Increase the maximum number of open files for macOS
if [[ $(uname) == "Darwin" ]]; then
    ulimit -s 40096 -n 81092
fi

make
dune exe ./bench/bin/scilla_bench_runner.exe -- -ci

git checkout -q perf-benchmarks

make
dune exe ./bench/bin/scilla_bench_runner.exe -- -ci
