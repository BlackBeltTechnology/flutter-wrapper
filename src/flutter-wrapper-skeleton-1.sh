#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ ! -d $SCRIPT_DIR/.flutter ]]; then
  echo "Flutter not found, installing..."
  git clone https://github.com/flutter/flutter.git -b beta --depth 1 $SCRIPT_DIR/.flutter
  $SCRIPT_DIR/.flutter/bin/flutter doctor
fi
