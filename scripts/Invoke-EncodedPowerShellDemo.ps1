<#
.SYNOPSIS
    Harmless simulation of an attacker using powershell -EncodedCommand (MITRE T1059.001 / T1027).
.DESCRIPTION
    Encodes a harmless Write-Host command as Base64 (UTF-16LE), runs it the way attackers do,
    and prints what to look for in Sysmon (Event ID 1) and how to decode it in CyberChef.
.EXAMPLE
    .\Invoke-EncodedPowerShellDemo.ps1
    .\Invoke-EncodedPowerShellDemo.ps1 -Message "Purple team test 42"
#>
param(
    [string] $Message = 'Hello Syed from Sysmon lab'
)

$command = "Write-Host '$Message'"
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))

Write-Host "Plain command : $command" -ForegroundColor Cyan
Write-Host "Encoded       : $encoded" -ForegroundColor Yellow
Write-Host ''
Write-Host 'Running: powershell -EncodedCommand <encoded>' -ForegroundColor Red
powershell.exe -NoProfile -EncodedCommand $encoded

Write-Host ''
Write-Host 'Now hunt it:' -ForegroundColor Green
Write-Host '  1. .\Get-SysmonEvents.ps1 -EventId 1 -Last 10 -Match EncodedCommand'
Write-Host '  2. CyberChef recipe: From Base64 -> Decode text (UTF-16LE 1200)'
