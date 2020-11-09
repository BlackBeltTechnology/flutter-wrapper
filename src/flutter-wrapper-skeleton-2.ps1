$env:CHROME_EXECUTABLE="$scriptDir\chromew.ps1"

$handle = Start-Process 'cmd' -ArgumentList "/c $flutter $args" -NoNewWindow -PassThru -Wait

exit
