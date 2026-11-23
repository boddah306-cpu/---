#requires -Version 5.1
<#
.SYNOPSIS
  NetisDash 빌드/실행 헬퍼 (JDK 21 + 외부 Tomcat 10.1 + Cargo).

.PARAMETER Action
  build   : mvn clean package
  run     : mvn cargo:run (포그라운드, http://localhost:8303/)
  start   : mvn cargo:start
  deploy  : mvn cargo:deploy
  stop    : mvn cargo:stop
  clean   : mvn clean
  all     : build 후 run (기본값)

.EXAMPLE
  .\run.ps1
  .\run.ps1 -Action run
  .\run.ps1 -Action build
#>
param(
    [ValidateSet('build','run','start','deploy','stop','clean','all')]
    [string]$Action = 'all',

    [string]$JavaHome    = 'C:\tools\jdk21\jdk-21.0.2'
)

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Test-Path $JavaHome)) {
    throw "JAVA_HOME not found: $JavaHome  (use -JavaHome to override)"
}

$env:JAVA_HOME = $JavaHome
$env:Path      = "$env:JAVA_HOME\bin;$env:Path"

Write-Host "JAVA_HOME = $env:JAVA_HOME"
& "$env:JAVA_HOME\bin\java.exe" -version

function Invoke-Mvn {
    param([string[]]$MvnArgs)
    Write-Host "`n> mvn $($MvnArgs -join ' ')`n" -ForegroundColor Cyan
    & mvn @MvnArgs
    if ($LASTEXITCODE -ne 0) { throw "mvn $($MvnArgs -join ' ') failed (exit $LASTEXITCODE)" }
}

switch ($Action) {
    'build'  { Invoke-Mvn @('clean','package') }
    'run'    { Invoke-Mvn @('-pl','hm-dash','cargo:run') }
    'start'  { Invoke-Mvn @('-pl','hm-dash','cargo:start') }
    'deploy' { Invoke-Mvn @('-pl','hm-dash','cargo:deploy') }
    'stop'   { Invoke-Mvn @('-pl','hm-dash','cargo:stop') }
    'clean'  { Invoke-Mvn @('clean') }
    'all'    {
        Invoke-Mvn @('clean','package')
        Invoke-Mvn @('-pl','hm-dash','cargo:run')
    }
}
