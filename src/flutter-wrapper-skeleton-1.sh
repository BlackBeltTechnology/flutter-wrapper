#!/bin/bash

###!/usr/bin/env sh

# Attempt to set SCRIPT_DIR
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
while [ -h "$PRG" ]; do
  ls=$(ls -ld "$PRG")
  link=$(expr "$ls" : '.*-> \(.*\)$')
  if expr "$link" : '/.*' >/dev/null; then
    PRG="$link"
  else
    PRG=$(dirname "$PRG")"/$link"
  fi
done

# Check for git
GIT=$(command -v git)
if [ -z $GIT ]; then
  echo "Git executable does not exists" 
fi

SAVED="$(pwd)"
cd "$(dirname "$PRG")/" >/dev/null
SCRIPT_DIR="$(pwd -P)"
cd "$SAVED" >/dev/null


# by default we should be in the correct project dir, but when run from Finder on Mac, the cwd is wrong
if [ "$(uname)" = "Darwin" ] && [ "$HOME" = "$PWD" ]; then
  cd "$(dirname "$0")"
fi

FLUTTER_SUBMODULE_NAME='.flutter'
FLUTTER_DIR="$SCRIPT_DIR/$FLUTTER_SUBMODULE_NAME"

GIT_REPO="false"

# If not a git repo, it used .flutter but it will not handled as submodule
if git rev-parse --git-dir > /dev/null 2>&1; then
  GIT_REPO="true"
else
  # echo "CHECKING: Not a git repository"
  if test -z "${FLUTTER_HOME-}"; then
    FLUTTER_HOME="$FLUTTER_DIR"
  fi
fi

# When flutter home given that flutter version used, there is no submodule handling
if test -n "${FLUTTER_HOME-}"; then
  # echo "Flutter HOME used: ${FLUTTER_HOME}"
  FLUTTER_DIR="$FLUTTER_HOME"
fi

#The given flutter dir does not exists, checking out
if [ ! -d "${FLUTTER_DIR}" ]; then
  echo "Flutter not found, installing..."
  if [ -z $FLUTTER_CHANNEL ]; then
    FLUTTER_CHANNEL=stable
  fi
  git clone https://github.com/flutter/flutter.git -b $FLUTTER_CHANNEL --depth 1 $FLUTTER_DIR
fi
# Flutter home not given, handling as submodule. When git parse does not now as submodule,
# the FLUTTEr_HOME variable set earlier
if test -z "${FLUTTER_HOME-}"; then
  # echo "Checking submodule"
  # submodule starting with "-" are not initialized
  init_status=$(git submodule | grep "\ $FLUTTER_SUBMODULE_NAME$" | cut -c 1)

  # Fix not initialized flutter submodule
  if [ "$init_status" = "-" ]; then
    echo "$FLUTTER_SUBMODULE_NAME submodule not initialized. Initializing..."
    git submodule update --init ${FLUTTER_SUBMODULE_NAME}
  fi
fi

# Detect detach HEAD and fix it. commands like upgrade expect a valid branch, not a detached HEAD
FLUTTER_SYMBOLIC_REF=$(git -C ${FLUTTER_DIR} symbolic-ref -q HEAD)
if [ -z ${FLUTTER_SYMBOLIC_REF} ]; then
  FLUTTER_REV=$(git -C ${FLUTTER_DIR} rev-parse HEAD)
  FLUTTER_CHANNEL=$(git config -f .gitmodules submodule.${FLUTTER_SUBMODULE_NAME}.branch)

  if [ -z $FLUTTER_CHANNEL ]; then
    echo "Warning: Submodule '$FLUTTER_SUBMODULE_NAME' doesn't point to an official Flutter channel \
(one of stable|beta|dev|master). './flutterw upgrade' will fail without a channel."
    echo "Fix this by adding a specific channel with:"
    echo "\t- './flutterw channel <channel>' or"
    echo "\t- Add 'branch = <channel>' to '$FLUTTER_SUBMODULE_NAME' submodule in .gitmodules"
  else
    echo "Fixing detached HEAD: '$FLUTTER_SUBMODULE_NAME' submodule points to a specific commit $FLUTTER_REV, not channel '$FLUTTER_CHANNEL' (as defined in .gitmodules)."
    # Make sure channel is fetched
    # Remove old channel branch because it might be moved to an unrelated commit where fast-forward pull isn't possible
    git -C ${FLUTTER_DIR} branch -q -D ${FLUTTER_CHANNEL} 2> /dev/null || true
    git -C ${FLUTTER_DIR} fetch -q origin

    # bind current HEAD to channel defined in .gitmodules
    git -C ${FLUTTER_DIR} checkout -q -b ${FLUTTER_CHANNEL} ${FLUTTER_REV}
    git -C ${FLUTTER_DIR} branch -q -u origin/${FLUTTER_CHANNEL} ${FLUTTER_CHANNEL}
    echo "Fixed! Migrated to channel '$FLUTTER_CHANNEL' while staying at commit $FLUTTER_REV. './flutterw upgrade' now works without problems!"
    git -C ${FLUTTER_DIR} status -bs
  fi
fi




