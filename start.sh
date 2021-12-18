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
#
# 

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
SCRIPTNAME="$0"
ARGS="$@"
BRANCH="master"
CURRENT_USER=$(whoami)
ANSIBLE_VERSION="5.0.1"

self_update() {
    cd $SCRIPTPATH
    git fetch

    if ! git diff --quiet remotes/origin/HEAD;
    then
        echo "Found a new version, updating..."
        git pull --force
        git checkout $BRANCH
        git pull --force
        echo "Update complete, terminating."
        exit 1
    fi
    echo "No updates found."
}

main() {
    echo "Starting main script"
    # create new python virtualenv (Python 3.9.6 is present on the box)
    python3 -m venv $HOME/venv_for_ansible
    source "$HOME/venv_for_ansible/bin/activate"
    pip install ansible==$ANSIBLE_VERSION
    ansible --version
    deactivate
}

self_update
main

