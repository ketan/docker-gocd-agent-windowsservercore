FROM microsoft/windowsservercore

COPY provision-scripts /Windows/Temp/provision-scripts
RUN powershell.exe -executionpolicy bypass c:/windows/temp/provision-scripts/00-all.ps1

COPY docker-entrypoint.ps1 /docker-entrypoint.ps1
ENTRYPOINT ["powershell", "-File", "/docker-entrypoint.ps1"]
