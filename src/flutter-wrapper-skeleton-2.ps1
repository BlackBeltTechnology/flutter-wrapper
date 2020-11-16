$env:CHROME_EXECUTABLE="$scriptDir\chromew.cmd"

$handle = Start-Process 'cmd' -ArgumentList "/c $flutter $args" -NoNewWindow -PassThru -Wait

exit
