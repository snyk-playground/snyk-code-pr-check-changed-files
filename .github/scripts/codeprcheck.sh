#!/bin/bash
# Requirements:
# - Sarif file from Snyk Code scan
# - Workflow in directory the Snyk Code Scan & diff are run on 
# - Update variable MERGE_BASE to merge-base (or otherwise update diff as needed eg. between PR & destination branch)
# - Node-JQ installed 
# Set Merge Base (main if there isn't one from GH)
snyk_sarif="${1}"
updatedsnyk_sarif="${2}"
MERGE_BASE=main
if [[ -z "${GITHUB_BASE_REF}" ]]; then
    MERGE_BASE=${GITHUB_BASE_REF}
# when tested with the juliet-test-suite-java repo, diff only saw tracked files so did not give added files, only modified
# I think when I first tested it in a small local repo I had to add/track new files
# could be me misunderstanding how to execute this or the only way to achieve is something like:
# https://stackoverflow.com/questions/855767/can-i-use-git-diff-on-untracked-files
# this outputs the diff to a jq friendly way and saves it to a variable
FILES_IN_DIFF_LIST=$(git diff --merge-base $MERGE_BASE --diff-filter=AM --name-only | jq --raw-input .| jq --slurp .)
# select results where the location uri does not match a filename from the diff
# delete results that were selected
# output into a file
jq --argjson FILES_IN_DIFF_LIST "$FILES_IN_DIFF_LIST" 'del(.runs[0].results[] | select([.locations[].physicalLocation.artifactLocation.uri] | inside ($FILES_IN_DIFF_LIST) | not))' $snyk_sarif > $updatedsnyk_sarif