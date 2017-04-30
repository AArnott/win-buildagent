FROM microsoft/dotnet-framework
LABEL maintainer andrewarnott@gmail.com
WORKDIR install.src

ADD https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe msbuild14.exe
RUN start /wait msbuild14.exe /q /full /log msbuild14.log

ADD https://aka.ms/vs/15/release/vs_community.exe vs_community.exe
RUN vs_community.exe -q --wait --includeRecommended --add Microsoft.VisualStudio.Workload.MSBuildTools --add Microsoft.VisualStudio.Workload.NetCoreTools
# Exercise dotnet.exe a bit so it expands its package cache
RUN dotnet new classlib -o dotnetCacheExpand
RUN rd /s /q dotnetCacheExpand

ADD https://github.com/git-for-windows/git/releases/download/v2.12.2.windows.2/Git-2.12.2.2-64-bit.exe GitForWindows.exe
RUN GitForWindows.exe /log="gitforwindows.log" /suppressmsgboxes /silent

ADD https://nodejs.org/dist/v6.10.2/node-v6.10.2-x64.msi node.msi
RUN start /wait msiexec.exe /i "node.msi"  /passive /norestart /l*v node.js.log
RUN npm i -g gulp

ADD https://www.python.org/ftp/python/2.7.13/python-2.7.13.msi python.msi
RUN start /wait msiexec.exe /i "python.msi" /passive /norestart /l*v python.log

ADD template /

WORKDIR /
