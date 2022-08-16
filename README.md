# Example for Snyk Code PR Check for Changed Files

![snyk-oss-category](https://github.com/snyk-labs/oss-images/blob/main/oss-example.jpg)

## Features
This repo contains a BASH workflow & script that provides additional functionality as part of a CI/CD Workflow:
* Run Snyk Code test to retrieve first-party code vulnerabilities and export the results as a SARIF
* Uses git diff between the merge-base and HEAD to get modified files
* Compares Snyk Code results to the modified files and exports an updated diff excluding results for files that weren't modified
* Creates a Snyk report Artifact

## Contents
* Forked Repo from [Goof](https://github.com/snyk-labs/nodejs-goof), A vulnerable Node.js demo application, based on the [Dreamers Lab tutorial](http://dreamerslab.com/blog/en/write-a-todo-list-with-express-and-mongodb/).
* [Bash Workflow](/.github/workflows/snyk-code-diff-pr-check.yml)
* [Bash Script](/.github/scripts/codeprcheck.sh)

## Running
* Fork this Repo
* Verify that a Snyk API token is configured as a secret for GH Actions
* Change the value of `--org` in line 24 of the Bash Workflow to the orgID for the Snyk Organization
* Commit Changes and Merge 
* View Snyk Report in the Artifacts within the Summary Page for Workflow Run in Actions
