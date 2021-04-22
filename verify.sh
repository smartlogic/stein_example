#!/bin/bash

set -e

GREEN='\033[0;32m'
BOLD=$(tput bold)
NORM=$(tput sgr0)

# $1 should be the header text
# Usage: header "foobar"
function header() {
    echo
    echo -e "${GREEN}${BOLD}$1${NORM}"
}

function lint() {
    header "LINTING"
    mix format --check-formatted
    mix compile --force --warnings-as-errors
    mix credo
    (cd assets && yarn lint:ci)
}

function test() {
    header "TESTING"
    mix test
    # (cd assets && yarn jest)
}

function audit() {
    header "AUDITING"
    mix hex.audit
}

lint
test
audit
