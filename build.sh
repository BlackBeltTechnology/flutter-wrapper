rm -rf dist
set -e

mkdir dist


CHROME_WRAPPER_SH=$(base64 src/chrome-wrapper.sh)
CHROME_WRAPPER_CMD=$(base64 src/Chrome-Wrapper.cmd)

# Flutterw linux/macOS

cat src/flutter-wrapper-skeleton-1.sh > dist/flutterw

echo "if test -n \"${CHROME_CORS_DISABLE-}\"; then" >> dist/flutterw
echo "  if [[ ! -f \$SCRIPT_DIR/chromew ]]; then" >> dist/flutterw
echo "    base64 -d <<<$CHROME_WRAPPER_SH > \$SCRIPT_DIR/chromew" >> dist/flutterw
echo "    chmod +x \$SCRIPT_DIR/chromew" >> dist/flutterw
echo "  fi" >> dist/flutterw
echo "  if [[ ! -f \$SCRIPT_DIR/Chromew.cmd ]]; then" >> dist/flutterw
echo "    base64 -d <<<$CHROME_WRAPPER_CMD > \$SCRIPT_DIR/Chromew.cmd" >> dist/flutterw
echo "  fi" >> dist/flutterw
echo "fi" >> dist/flutterw

cat src/flutter-wrapper-skeleton-2.sh >> dist/flutterw
chmod +x dist/flutterw

# Flutterw ps1
cat src/flutter-wrapper-skeleton-1.ps1 > dist/flutterw.ps1

echo "\$chromewsh = \"\$scriptDir\\\chromew\"" >> dist/flutterw.ps1
echo "if (!(Test-Path \$chromewsh)) {" >> dist/flutterw.ps1
echo "  \$Content = [System.Convert]::FromBase64String(\"$CHROME_WRAPPER_SH\")" >> dist/flutterw.ps1
echo "  Set-Content -Path \$chromewsh -Value \$Content -Encoding Byte" >> dist/flutterw.ps1
echo "}" >> dist/flutterw.ps1

echo "\$chromewcmd = \"\$scriptDir\\\chromew.cmd\"" >> dist/flutterw.ps1
echo "if (!(Test-Path \$chromewcmd)) {" >> dist/flutterw.ps1
echo "  \$Content = [System.Convert]::FromBase64String(\"$CHROME_WRAPPER_CMD\")" >> dist/flutterw.ps1
echo "  Set-Content -Path \$chromewcmd -Value \$Content -Encoding Byte" >> dist/flutterw.ps1
echo "}" >> dist/flutterw.ps1

cat src/flutter-wrapper-skeleton-2.ps1 >> dist/flutterw.ps1

chmod +x dist/flutterw

