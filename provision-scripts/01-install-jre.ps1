$ErrorActionPreference = "Stop"
$progressPreference = 'silentlyContinue'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


$downloadPage = 'http://www.oracle.com/'
# $downloadUrl = 'http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jre-8u181-windows-x64.tar.gz'
$downloadUrl = 'http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jre-8u181-windows-x64.exe'

$jreExecutable = 'C:\Windows\Temp\provision-scripts\jre.exe'

# invoke a web request and save the session in `$session`
Invoke-WebRequest $downloadPage -UseBasicParsing -UseDefaultCredentials -SessionVariable session | Out-Null
$cookies = New-Object System.Net.Cookie("oraclelicense", "accept-securebackup-cookie", "/", ".oracle.com")
$session.Cookies.Add($downloadPage, $cookies)
Write-Host "Downloading JRE"
Invoke-WebRequest $downloadUrl -UseBasicParsing -UseDefaultCredentials -WebSession $session -OutFile $jreExecutable
Write-Host "Done downloading JRE"

Unblock-File $jreExecutable | Out-Null
Write-Host "Installing jre to C:\jre"
Start-Process $jreExecutable -ArgumentList '/s INSTALLDIR=C:\jre INSTALL_SILENT=1 STATIC=1 AUTO_UPDATE=0 WEB_JAVA=0 EULA=0 REBOOT=0 NOSTARTMENU=0 SPONSORS=0 /L C:\jre.log' -NoNewWindow -Wait
