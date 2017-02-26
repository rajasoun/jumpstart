:: Bootstrap Script To Setup CK Windows Dev Box

SET DIR=%~dp0%

::Download Installation Script (install.ps1) For chocolatey
%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "((new-object net.webclient).DownloadFile('https://chocolatey.org/install.ps1','install.ps1'))"

::Run Installer
%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& '%DIR%install.ps1' %*"

:: SHell with Package Manager
choco install --force  -y  babun


:: Tabbed console
:: choco install --force -y conemu


:: Launch Babun

:: VM Setup
:: choco install --force  -y  virtualbox
:: choco install --force  -y  vagrant
:: choco install --force  -y  virtualbox.extensionpack

:: Network tools
:: choco install --force  -y nmap


:: Development tools
:: choco install --force -y meld
:: choco install --force -y wincommandpaste
:: choco install --force -y sublimetext2

:: choco install --force -y  docker
:: choco install --force -y  docker-machine
:: choco install --force -y  docker-compose

:: As of Now Below Items Don't Have chocolately installer, so download into a installers directory
:: if not exist ".\installers" mkdir installers

:: CPP Build tools, needed for node-gyp, python etc
:: @powershell -NoProfile -ExecutionPolicy Bypass -Command  "(new-object System.Net.WebClient).Downloadfile('https://download.microsoft.com/download/3/8/E/38EE4758-7C31-4D96-8FF9-83CC313F0F78/VisualCppBuildTools_Full.exe', '.\installers\VisualCppBuildTools_Full.exe')"

:: Open installers direcotry
:: explorer.exe installers
