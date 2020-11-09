rm -rf dist
set -e

mkdir dist


CHROME_WRAPPER_SH=$(base64 src/chrome-wrapper.sh)
CHROME_WRAPPER_PS1=$(base64 src/Chrome-Wrapper.ps1)

# Dlutterw linux/macOS

cat src/flutter-wrapper-skeleton-1.sh > dist/flutterw

echo "if [[ ! -f \$SCRIPT_DIR/chromew ]]; then" >> dist/flutterw
echo "  base64 -d <<<$CHROME_WRAPPER_SH > \$SCRIPT_DIR/chromew" >> dist/flutterw
echo "  chmod +x \$SCRIPT_DIR/chromew" >> dist/flutterw

echo "fi" >> dist/flutterw
echo "if [[ ! -f \$SCRIPT_DIR/Chromew.ps1 ]]; then" >> dist/flutterw
echo "  base64 -d <<<$CHROME_WRAPPER_PS1 > \$SCRIPT_DIR/Chromew.ps1" >> dist/flutterw
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

echo "\$chromewps1 = \"\$scriptDir\\\chromew.ps1\"" >> dist/flutterw.ps1
echo "if (!(Test-Path \$chromewps1)) {" >> dist/flutterw.ps1
echo "  \$Content = [System.Convert]::FromBase64String(\"$CHROME_WRAPPER_PS1\")" >> dist/flutterw.ps1
echo "  Set-Content -Path \$chromewps1 -Value \$Content -Encoding Byte" >> dist/flutterw.ps1
echo "}" >> dist/flutterw.ps1

cat src/flutter-wrapper-skeleton-2.ps1 >> dist/flutterw.ps1

chmod +x dist/flutterw

