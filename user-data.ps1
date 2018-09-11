<powershell>
# install docker
Install-Module DockerMsftProvider -Force
Install-Package Docker -ProviderName DockerMsftProvider -Force
Start-Service Docker
Set-Service -Name Docker -StartupType Automatic

# install powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install -y conemu firefox vscode git

# restart!
Restart-Computer
</powershell>

