# Use the -m 2GB switch so that the VS 2017 installer has all the memory it requires.
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2017
# docker build -t andrewarnott/win-buildagent -m 2GB .

FROM microsoft/dotnet-framework:3.5
LABEL maintainer andrewarnott@gmail.com
WORKDIR install.src

ADD https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe msbuild14.exe
RUN start /wait msbuild14.exe /q /full /log msbuild14.log

ADD https://www.python.org/ftp/python/2.7.15/python-2.7.15.amd64.msi python.msi
RUN start /wait msiexec.exe /i "python.msi" /passive /norestart /l*v python.log

RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin" && choco feature enable -n allowGlobalConfirmation

ADD https://nodejs.org/dist/v8.11.4/node-v8.11.4-x64.msi node.msi
RUN start /wait msiexec.exe /i "node.msi"  /passive /norestart /l*v node.js.log
RUN npm i -g gulp

ADD https://download.mono-project.com/archive/5.14.0/windows-installer/mono-5.14.0.177-x64-0.msi mono.msi
RUN start /wait msiexec.exe /i "mono.msi" /passive /norestart /l*v mono.log

ADD https://github.com/git-for-windows/git/releases/download/v2.18.0.windows.1/Git-2.18.0-64-bit.exe GitForWindows.exe
RUN GitForWindows.exe /log="gitforwindows.log" /suppressmsgboxes /silent

ADD https://aka.ms/vs/15/release/vs_community.exe vs_community.exe
RUN vs_community.exe -q --wait --norestart --nocache --includeRecommended \
    --add Microsoft.VisualStudio.Workload.MSBuildTools \
    --add Microsoft.VisualStudio.Workload.NetCoreTools \
    --add Microsoft.Net.ComponentGroup.DevelopmentPrerequisites \
    --add Microsoft.Net.ComponentGroup.TargetingPacks.Common \
    --add Microsoft.Net.ComponentGroup.4.6.2.DeveloperTools \
    --add Microsoft.Net.ComponentGroup.4.7.DeveloperTools \
    --add Microsoft.Net.Component.3.5.DeveloperTools
# Exercise dotnet.exe a bit so it expands its package cache
RUN dotnet new classlib -o dotnetCacheExpand \
    && rd /s /q dotnetCacheExpand

ADD https://dot.net/v1/dotnet-install.ps1 dotnet-install.ps1
RUN powershell -c "./dotnet-install.ps1 -Version 2.1.300 -InstallDir $env:ProgramFiles\\dotnet"

ADD template /

ENV \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 \
    DOTNET_CLI_TELEMETRY_OPTOUT=1

WORKDIR /

# Start developer command prompt with any other commands specified.
ENTRYPOINT C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat &&

# Default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
