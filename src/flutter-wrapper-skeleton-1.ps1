$scriptDir = split-path -parent $MyInvocation.MyCommand.Definition
$flutterDir = "$scriptDir\flutter"
$flutter = "$scriptDir\flutter\bin\flutter"

if (!(Test-Path $flutterDir)) {
  Write-Output "Flutter not found, installing..."
  git clone https://github.com/flutter/flutter.git -b beta --depth 1 $scriptDir\flutter
  $handle = Start-Process 'cmd' -ArgumentList "/c $flutter doctor" -NoNewWindow -PassThru -Wait
}
