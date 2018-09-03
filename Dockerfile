# escape=\

FROM microsoft/dotnet-framework:3.5
LABEL maintainer andrewarnott@gmail.com
WORKDIR install.src

ADD lib/en_visual_studio_community_2015_with_update_3_x86_x64_web_installer_8922963.exe vs2015.exe
RUN cmd /c start /wait .\vs2015.exe /l vs2015.log /q /norestart /full

ADD https://www.python.org/ftp/python/2.7.15/python-2.7.15.amd64.msi python.msi
RUN start /wait msiexec.exe /i "python.msi" /passive /norestart /l*v python.log

RUN @powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" \
    && SET "PATH=%PATH%;%ALLUSERSPROFILE%\\chocolatey\\bin" \
    && choco feature enable -n allowGlobalConfirmation

ADD https://nodejs.org/dist/v8.11.4/node-v8.11.4-x64.msi node.msi
RUN start /wait msiexec.exe /i "node.msi"  /passive /norestart /l*v node.js.log
RUN npm i -g gulp

ADD https://download.mono-project.com/archive/5.14.0/windows-installer/mono-5.14.0.177-x64-0.msi mono.msi
RUN start /wait msiexec.exe /i "mono.msi" /passive /norestart /l*v mono.log

ADD https://github.com/git-for-windows/git/releases/download/v2.18.0.windows.1/Git-2.18.0-64-bit.exe GitForWindows.exe
RUN GitForWindows.exe /log="gitforwindows.log" /suppressmsgboxes /silent

# The IDs used here are documented at:
# https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-community?view=vs-2017
ADD https://aka.ms/vs/15/release/vs_community.exe vs_community.exe
RUN vs_community.exe -q --wait --includeRecommended \
    --add Microsoft.VisualStudio.Workload.MSBuildTools \
    --add Microsoft.VisualStudio.Workload.NetCoreTools \
    --add Microsoft.VisualStudio.Workload.Universal \
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

WORKDIR /
