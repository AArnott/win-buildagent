# win-buildagent
Docker image build for a windows build agent

[![Build status](https://ci.appveyor.com/api/projects/status/nl2kcvgo276o82df/branch/master?svg=true)](https://ci.appveyor.com/project/AArnott/win-buildagent/branch/master)
[![DockerHub pull count](https://img.shields.io/docker/pulls/andrewarnott/win-buildagent.svg)](https://hub.docker.com/r/andrewarnott/win-buildagent/)

Docker image requires Windows 10 and includes:

* MSBuild 14.0
* Visual Studio 2017 Community
  * MSBuild 15.1
  * dotnet CLI
* Node.js 6.10.2
  * gulp
* Git for Windows 2.12.2.2
