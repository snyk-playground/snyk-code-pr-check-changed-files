#!/bin/bash
# snyk_sarif and updatedsnyk_sarif are the input and output respectively
# the file names are specified when running the script from the workflow (snyk-code-diff-pr-check.yml) 
snyk_sarif="${1}"
updatedsnyk_sarif="${2}"
# default merge base is main, but in a GitHub PR, the merge-base is the target branch of the PR
MERGE_BASE="main"
if [[ ! -z "${GITHUB_BASE_REF}" ]]; then
    MERGE_BASE=${GITHUB_BASE_REF}
fi
# retrieves the branches for the repo in preperation for the diff
git fetch --no-tags --depth=1 --prune origin +refs/heads/*:refs/remotes/origin/*
# uses a diff between the head & the merge-base to get the modified files and makes that the value of a variable (FILES_IN_DIFF_LIST)
FILES_IN_DIFF_LIST=$(git diff "origin/${MERGE_BASE}" "origin/${GITHUB_HEAD_REF}" --diff-filter=AM --name-only)
# makes the diff output a jq-friendly value and updates that as the value of FILES_IN_DIFF_LIST
FILES_IN_DIFF_LIST=$(echo "${FILES_IN_DIFF_LIST}" | jq --raw-input .| jq --slurp .)
# make a json variable of FILES_IN_DIFF_LIST using the variable previously created with the same name
# select results from the input (snyk_sarif) where the location uri does not match a filename from the diff
# delete results that were selected
# output into a file (updatedsnyk_sarif)
jq --argjson FILES_IN_DIFF_LIST "$FILES_IN_DIFF_LIST" 'del(.runs[0].results[] | select([.locations[].physicalLocation.artifactLocation.uri] | inside ($FILES_IN_DIFF_LIST) | not))' $snyk_sarif > $updatedsnyk_sarif
