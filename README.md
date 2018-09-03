# win-buildagent
Docker image build for a windows build agent

[![Build status](https://ci.appveyor.com/api/projects/status/nl2kcvgo276o82df/branch/master?svg=true)](https://ci.appveyor.com/project/AArnott/win-buildagent/branch/master)
[![DockerHub pull count](https://img.shields.io/docker/pulls/andrewarnott/win-buildagent.svg)](https://hub.docker.com/r/andrewarnott/win-buildagent/)

Docker image requires Windows 10 and includes:

* .NET Framework 3.5 and 4.6.2
* Visual Studio 2015 Community
* Visual Studio 2017 Community
  * MSBuild 15
  * dotnet CLI
    * v2.1.300 SDK
* Mono 5.14.0
* Node.js 8.11.4
  * gulp
* Python 2.7.15
* Git for Windows 2.18.0
* Chocolatey
