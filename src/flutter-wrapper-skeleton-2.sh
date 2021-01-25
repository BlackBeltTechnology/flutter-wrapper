if test -n "${CHROME_CORS_DISABLE-}"; then
  export CHROME_EXECUTABLE="$SCRIPT_DIR/chromew"
fi

# Wrapper tasks done, call flutter binay with all args
set -e
"$FLUTTER_DIR/bin/flutter" "$@"

# Post flutterw tasks. exit code from /bin/flutterw will be used as final exit
FLUTTER_EXIT_STATUS=$?
if [ ${FLUTTER_EXIT_STATUS} -eq 0 ]; then

  if test -n "${FLUTTER_HOME-}"; then

    # ./flutterw channel CHANNEL
    if echo "$@" | grep -q "channel"; then
      # make sure .gitmodules is updated as well
      CHANNEL=${2} # second arg
      git config -f .gitmodules submodule.${FLUTTER_SUBMODULE_NAME}.branch ${CHANNEL}
      # makes sure nobody forgets to do commit all changed files
      git add .gitmodules
      git add ${FLUTTER_SUBMODULE_NAME}
    fi

    # ./flutterw upgrade
    if echo "$@" | grep -q "upgrade"; then
      # makes sure nobody forgets to do commit the changed submodule
      git add ${FLUTTER_SUBMODULE_NAME}
      # flutter packages get runs automatically. Stage those changes as well
      git add pubspec.lock
    fi
  fi
fi
exit ${FLUTTER_EXIT_STATUS}

