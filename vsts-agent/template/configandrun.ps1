if (-not $env:ACCOUNT) {
    Write-Error "ACCOUNT environment variable must be specified."
}
if (-not $env:POOL) {
    Write-Error "POOL environment variable must be specified."
}
if (-not $env:PAT) {
    Write-Error "PAT environment variable must be specified."
}

if ($env:AgentName) {
    $agent = $env:AgentName
} else {
    $agent = "$(Get-Date).ToString('yyyy-M-d-HH-mm-ss')"
}

./config.cmd --unattended --replace --url https://${env:ACCOUNT}.visualstudio.com --acceptTeeEula --auth pat --pool $env:POOL --agent $agent --token $env:PAT
./run.cmd
