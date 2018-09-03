FROM andrewarnott/win-buildagent:latest

ARG ACCOUNT=andrewarnott
ENV ACCOUNT $ACCOUNT
ARG POOL=default
ENV POOL $POOL

WORKDIR /install.src

ADD https://vstsagentpackage.azureedge.net/agent/2.139.1/vsts-agent-win-x64-2.139.1.zip vsts.zip

WORKDIR /agent

RUN powershell -c "Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory('../install.src/vsts.zip', $PWD)"

ADD template .

ENTRYPOINT ["powershell.exe", "-c", "./configandrun.ps1"]
