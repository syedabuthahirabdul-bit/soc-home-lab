<#
.SYNOPSIS
    Installs (or updates the config of) Sysmon using the SwiftOnSecurity config.
.DESCRIPTION
    Expects Sysmon64.exe and sysmonconfig-export.xml in -SysmonFolder.
    Download Sysmon: https://learn.microsoft.com/sysinternals/downloads/sysmon
    Download config: https://github.com/SwiftOnSecurity/sysmon-config
    Must be run in PowerShell as Administrator.
.EXAMPLE
    .\Install-Sysmon.ps1 -SysmonFolder "D:\sysmon\Sysmon"
#>
param(
    [Parameter(Mandatory)] [string] $SysmonFolder,
    [string] $ConfigFile = 'sysmonconfig-export.xml'
)

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error 'Run PowerShell as Administrator (right-click > Run as administrator).'
    exit 1
}

$exe = Join-Path $SysmonFolder 'Sysmon64.exe'
$cfg = Join-Path $SysmonFolder $ConfigFile
foreach ($f in @($exe, $cfg)) {
    if (-not (Test-Path $f)) { Write-Error "Not found: $f"; exit 1 }
}

if (Get-Service Sysmon64 -ErrorAction SilentlyContinue) {
    Write-Host 'Sysmon already installed - updating configuration...'
    & $exe -c $cfg
} else {
    Write-Host 'Installing Sysmon...'
    & $exe -accepteula -i $cfg
}

Get-Service Sysmon64 | Format-Table Status, Name, DisplayName -AutoSize
