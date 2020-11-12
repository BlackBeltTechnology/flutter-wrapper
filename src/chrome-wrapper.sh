#!/bin/sh
if [ "`uname`" = "Darwin" ]; then
  CHROME_BIN=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
elif [ "`uname`" = "Linux" ]; then
  CHROME_BIN=$(which google-chrome)
else
  echo "Unsupported OS"
  exit 1
fi

echo "Chrome: $CHROME_BIN"
if [ ! -f "${CHROME_BIN}" ]; then
  echo "Google chrome not found"
  exit 1
fi

#exe c bash -c "exec ${CHROME_BIN} --disable-web-security --user-data-dir=\".chrome\" $*"

"$CHROME_BIN" --disable-web-security --user-data-dir=".chrome" $*