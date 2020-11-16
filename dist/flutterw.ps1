$scriptDir = split-path -parent $MyInvocation.MyCommand.Definition
$flutterDir = "$scriptDir\.flutter"
$flutter = "$scriptDir\.flutter\bin\flutter"

if (!(Test-Path $flutterDir)) {
  Write-Output "Flutter not found, installing..."
  git clone https://github.com/flutter/flutter.git -b beta --depth 1 $scriptDir\.flutter
  $handle = Start-Process 'cmd' -ArgumentList "/c $flutter doctor" -NoNewWindow -PassThru -Wait
}
$chromewsh = "$scriptDir\chromew"
if (!(Test-Path $chromewsh)) {
  $Content = [System.Convert]::FromBase64String("IyEvYmluL3NoCmlmIFsgImB1bmFtZWAiID0gIkRhcndpbiIgXTsgdGhlbgogIENIUk9NRV9CSU49L0FwcGxpY2F0aW9ucy9Hb29nbGVcIENocm9tZS5hcHAvQ29udGVudHMvTWFjT1MvR29vZ2xlXCBDaHJvbWUKZWxpZiBbICJgdW5hbWVgIiA9ICJMaW51eCIgXTsgdGhlbgogIENIUk9NRV9CSU49JCh3aGljaCBnb29nbGUtY2hyb21lKQplbHNlCiAgZWNobyAiVW5zdXBwb3J0ZWQgT1MiCiAgZXhpdCAxCmZpCgplY2hvICJDaHJvbWU6ICRDSFJPTUVfQklOIgppZiBbICEgLWYgIiR7Q0hST01FX0JJTn0iIF07IHRoZW4KICBlY2hvICJHb29nbGUgY2hyb21lIG5vdCBmb3VuZCIKICBleGl0IDEKZmkKCiNleGUgYyBiYXNoIC1jICJleGVjICR7Q0hST01FX0JJTn0gLS1kaXNhYmxlLXdlYi1zZWN1cml0eSAtLXVzZXItZGF0YS1kaXI9XCIuY2hyb21lXCIgJCoiCgoiJENIUk9NRV9CSU4iIC0tZGlzYWJsZS13ZWItc2VjdXJpdHkgLS11c2VyLWRhdGEtZGlyPSIuY2hyb21lIiAkKg==")
  Set-Content -Path $chromewsh -Value $Content -Encoding Byte
}
$chromewcmd = "$scriptDir\chromew.cmd"
if (!(Test-Path $chromewcmd)) {
  $Content = [System.Convert]::FromBase64String("ImM6XFByb2dyYW0gRmlsZXMgKHg4NilcR29vZ2xlXENocm9tZVxBcHBsaWNhdGlvblxjaHJvbWUuZXhlIiAtLWRpc2FibGUtd2ViLXNlY3VyaXR5IC0tdXNlci1kYXRhLWRpcj0iLmNocm9tZSIgJSo=")
  Set-Content -Path $chromewcmd -Value $Content -Encoding Byte
}
$env:CHROME_EXECUTABLE="$scriptDir\chromew.cmd"

$handle = Start-Process 'cmd' -ArgumentList "/c $flutter $args" -NoNewWindow -PassThru -Wait

exit
