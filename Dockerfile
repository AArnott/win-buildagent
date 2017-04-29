FROM microsoft/dotnet-framework
LABEL maintainer andrewarnott@gmail.com
WORKDIR install.src

ADD https://download.microsoft.com/download/E/E/D/EEDF18A8-4AED-4CE0-BEBE-70A83094FC5A/BuildTools_Full.exe msbuild14.exe
RUN start /wait msbuild14.exe /q /full /log msbuild14.log

