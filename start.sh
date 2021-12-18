#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Objective: To check if a newer version of this repo is present 
# on github. If present - update and quit. If we are running the
# latest version, run rest of the script.
#
# (It might be possible to continue running after updating, but 
# I am concerned that my reporting tools would not accurately
# identify sub-commands created in other shells. This will keep
# things simple)
#
# bash auto-update ref: https://stackoverflow.com/a/35365800
#
# 

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
SCRIPTNAME="$0"
ARGS="$@"
BRANCH="master"

self_update() {
    cd $SCRIPTPATH
    git fetch

    if [ $(git rev-parse HEAD) = $(git rev-parse @{u}) ]
    then
        echo "Found a new version of me, updating..."
        git pull --force
        git checkout $BRANCH
        git pull --force
        echo "Update complete, terminating."
        exit 1
    fi
    echo "Already the latest version."
}

main() {
   echo "Running main script"
}

self_update
main

