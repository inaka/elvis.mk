#!/bin/bash

set -e

fail() {
    echo -e "\033[31mError: $1\033[0m"
    exit 1
}

prepare_test() {
    rm -rf _build elvis elvis.config out.log
    echo -e "--- \033[32mTest: $1 \033[0m ---"
}

cleanup() {
    rm -f rebar3 erlang.mk elvis elvis.config out.log
    rm -rf _build .erlang.mk
}

finished_test() {
    echo -e "--- \033[32mTest passed\033[0m ---"
}

cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null

cleanup

echo "Preparing ..."
echo -n "Downloading Erlang.mk ..."
curl -sLfo erlang.mk https://erlang.mk/erlang.mk
echo " OK"

echo -n "Downloading Rebar3 ..."
curl -sLfo rebar3 https://s3.amazonaws.com/rebar3/rebar3
chmod a+x rebar3
echo " OK"

echo "Doing the initial make ..."
make > /dev/null

prepare_test "Local rebar3, no build dir, no elvis.config"
ELVIS_REBAR3=$(pwd)/rebar3 make elvis || fail "make failed, exit code $?"

[ -x elvis ] || fail "Elvis executable not found"
[ -f elvis.config ] || fail "elvis.config not found"
[ -e _build ] && fail "build dir ('_build') not removed"

cp test-elvis.config elvis.config
make elvis > out.log 2>&1 || fail "Elvis rock failed, exit code $?"
[ ! -s out.log ] || (echo "--- out.log ---" && \
    cat out.log && \
    echo "---" && \
    fail "Elvis rock output (out.log) not empty")
finished_test

prepare_test "Remote rebar3, existing build dir, existing elvis.config"
mkdir -p _build/existing
export ELVIS_REBAR3=not-to-be-found
rm rebar3
cp test-elvis.config elvis.config

make elvis || fail "make failed, exit code $?"

[ -x elvis ] || fail "Elvis executable not found"
cmp --silent test-elvis.config elvis.config || fail "elvis.config was overwritten"
[ -e _build ] || fail "build dir ('_build') removed"

make elvis > out.log 2>&1 || fail "Elvis rock failed, exit code $?"
[ ! -s out.log ] || (echo "--- out.log ---" && \
    cat out.log && \
    echo "---" && \
    fail "Elvis rock output (out.log) not empty")
finished_test

cleanup
