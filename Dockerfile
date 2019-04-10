FROM microsoft/dotnet-framework:3.5 AS tools
WORKDIR /install.src

ADD https://www.7-zip.org/a/7z1900-x64.msi 7z.msi
RUN start /wait msiexec.exe /i "7z.msi" /passive /norestart /l*v 7z.log

ADD https://github.com/coreybutler/nvm-windows/releases/download/1.1.7/nvm-setup.zip nvm-setup.zip
RUN ""c:\Program Files\7-Zip\7z.exe" e nvm-setup.zip"

#########

FROM microsoft/dotnet-framework:3.5
LABEL maintainer andrewarnott@gmail.com
WORKDIR /install.src

ADD https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe msbuild14.exe
RUN start /wait msbuild14.exe /q /full /log msbuild14.log

ADD https://www.python.org/ftp/python/2.7.16/python-2.7.16.amd64.msi python.msi
RUN start /wait msiexec.exe /i "python.msi" /passive /norestart /l*v python.log

RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" && choco feature enable -n allowGlobalConfirmation

ADD https://nodejs.org/dist/v10.15.3/node-v10.15.3-x64.msi node.msi
RUN start /wait msiexec.exe /i "node.msi"  /passive /norestart /l*v node.js.log
RUN npm i -g gulp

COPY --from=tools /install.src/nvm-setup.exe nvm-setup.exe
RUN nvm-setup.exe /suppressmsgboxes /silent /log="nvm.log"

ADD https://download.mono-project.com/archive/5.18.1/windows-installer/mono-5.18.1.3-x64-0.msi mono.msi
RUN start /wait msiexec.exe /i "mono.msi" /passive /norestart /l*v mono.log

ADD https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe GitForWindows.exe
RUN GitForWindows.exe /log="gitforwindows.log" /suppressmsgboxes /silent

ADD https://aka.ms/vs/16/release/vs_buildtools.exe vs_buildtools.exe

# Install Build Tools excluding workloads and components with known issues.
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2019
RUN vs_buildtools.exe -q --wait --norestart --nocache \
    --installPath C:\BuildTools \
    --all \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 \
    --remove Microsoft.VisualStudio.Component.Windows81SDK \
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

ADD https://dot.net/v1/dotnet-install.ps1 dotnet-install.ps1
RUN powershell -c "./dotnet-install.ps1 -Version 2.2.105 -InstallDir $env:ProgramFiles\\dotnet"
RUN powershell.exe -Command $path = $env:path + ';c:\Program Files\dotnet'; Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Value $path

# Exercise dotnet.exe a bit so it expands its package cache
RUN dotnet new classlib -o dotnetCacheExpand && \
    rd /s /q dotnetCacheExpand

ADD template /

# Start developer command prompt with any other commands specified.
ENTRYPOINT C:\BuildTools\Common7\Tools\VsDevCmd.bat &&

# Default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]

WORKDIR /
