$scriptDir = split-path -parent $MyInvocation.MyCommand.Definition
$flutterDir = "$scriptDir\.flutter"
$flutter = "$scriptDir\.flutter\bin\flutter"

if (!(Test-Path $flutterDir)) {
  Write-Output "Flutter not found, installing..."
  git clone https://github.com/flutter/flutter.git -b beta --depth 1 $scriptDir\flutter
  $handle = Start-Process 'cmd' -ArgumentList "/c $flutter doctor" -NoNewWindow -PassThru -Wait
}
$chromewsh = "$scriptDir\chromew"
if (!(Test-Path $chromewsh)) {
  $Content = [System.Convert]::FromBase64String("IyEvYmluL3NoCmlmIFtbICIkT1NUWVBFIiA9PSAiZGFyd2luIiogXV07IHRoZW4KICBDSFJPTUVfQklOPS9BcHBsaWNhdGlvbnMvR29vZ2xlXCBDaHJvbWUuYXBwL0NvbnRlbnRzL01hY09TL0dvb2dsZVwgQ2hyb21lCmVsaWYgW1sgIiRPU1RZUEUiID09ICJsaW51eC1nbnUiKiBdXTsgdGhlbgogIENIUk9NRV9CSU49JCh3aGljaCBnb29nbGUtY2hyb21lKQplbHNlCiAgZWNobyAiVW5zdXBwb3J0ZWQgT1MiCiAgZXhpdCAxCmZpCgplY2hvICJDaHJvbWU6ICRDSFJPTUVfQklOIgppZiBbWyAhIC1mICIke0NIUk9NRV9CSU59IiBdXTsgdGhlbgogIGVjaG8gIkdvb2dsZSBjaHJvbWUgbm90IGZvdW5kIgogIGV4aXQgMQpmaQoKI2V4ZSBjIGJhc2ggLWMgImV4ZWMgJHtDSFJPTUVfQklOfSAtLWRpc2FibGUtd2ViLXNlY3VyaXR5IC0tdXNlci1kYXRhLWRpcj1cIi5jaHJvbWVcIiAkKiIKCiIkQ0hST01FX0JJTiIgLS1kaXNhYmxlLXdlYi1zZWN1cml0eSAtLXVzZXItZGF0YS1kaXI9Ii5jaHJvbWUiICQqCg==")
  Set-Content -Path $chromewsh -Value $Content -Encoding Byte
}
$chromewps1 = "$scriptDir\chromew.ps1"
if (!(Test-Path $chromewps1)) {
  $Content = [System.Convert]::FromBase64String("ImM6XFByb2dyYW0gRmlsZXMgKHg4NilcR29vZ2xlXENocm9tZVxBcHBsaWNhdGlvblxjaHJvbWUuZXhlIiAtLWRpc2FibGUtd2ViLXNlY3VyaXR5IC0tdXNlci1kYXRhLWRpcj0iLmNocm9tZSIgJSo=")
  Set-Content -Path $chromewps1 -Value $Content -Encoding Byte
}
$env:CHROME_EXECUTABLE="$scriptDir\chromew.ps1"

$handle = Start-Process 'cmd' -ArgumentList "/c $flutter $args" -NoNewWindow -PassThru -Wait

exit
