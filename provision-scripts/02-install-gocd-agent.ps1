$ErrorActionPreference = "Stop"
$progressPreference = 'silentlyContinue'

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$downloadUrl = 'https://download.gocd.org/binaries/18.8.0-7433/generic/go-agent-18.8.0-7433.zip'

$gocdInstallerZip = 'C:\Windows\Temp\provision-scripts\gocd-agent.zip'

Write-Host "Downloading GoCD installer zip"
Invoke-WebRequest $downloadUrl -UseBasicParsing -UseDefaultCredentials -OutFile $gocdInstallerZip
Write-Host "Finished downloading GoCD installer zip"

Write-Host "Extracting GoCD agent to C:\go"
Expand-Archive -Path $gocdInstallerZip -DestinationPath C:\

# the above creates a `C:\go-agent-VERSION` directory, we rename to `C:\go`
Get-ChildItem "C:\" | 
    Where {$_.Name -Match 'go-agent-'} | 
    Rename-Item -NewName {$_.name -replace 'go-agent-.*', 'go' }
Write-Host "Done extracting GoCD agent to C:\go"

