#!/usr/bin/env bash

set -ex

download_gherkin()
{
    wildcardFlag="--wildcards"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        wildcardFlag=""
    fi

    rm -rf ${1} && mkdir -p ${1}
    for run in 1 2 3 4 5
    do
        if [ -x "$(command -v gtar)" ]; then
            curl --silent --fail https://codeload.github.com/elastic/apm/tar.gz/${2} | gtar xzvf - ${wildcardFlag} --directory=${1} --strip-components=4 "*/tests/agents/gherkin-specs*"
        else
            curl --silent --fail https://codeload.github.com/elastic/apm/tar.gz/${2} | tar xzvf - ${wildcardFlag} --directory=${1} --strip-components=4 "*tests/agents/gherkin-specs*"
        fi
        result=$?
        if [ $result -eq 0 ]; then break; fi
        sleep 1
    done

    if [ $result -ne 0 ]; then exit $result; fi

}

# parent directory
basedir=$(dirname "$0")
targetdir="${1:-"bdd/features"}"
branch="${2:-"master"}"

download_gherkin ${basedir}/${targetdir} ${branch}

echo "Done."
