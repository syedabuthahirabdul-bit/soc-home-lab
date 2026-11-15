<#
.SYNOPSIS
    Checks which SOC home-lab tools are installed and running.
.EXAMPLE
    .\Check-LabTools.ps1
#>

$results = @()

function Add-Result($Name, $Ok, $Detail) {
    $script:results += [pscustomobject]@{
        Tool   = $Name
        Status = if ($Ok) { 'OK' } else { 'MISSING' }
        Detail = $Detail
    }
}

# Nmap
$nmap = Get-Command nmap -ErrorAction SilentlyContinue
if ($nmap) {
    $ver = (& nmap --version | Select-Object -First 1)
    Add-Result 'Nmap' $true $ver
} else {
    Add-Result 'Nmap' $false 'Install from https://nmap.org/download'
}

# Npcap
$npcap = Get-Service npcap -ErrorAction SilentlyContinue
Add-Result 'Npcap' ($null -ne $npcap) ($(if ($npcap) { "Service: $($npcap.Status)" } else { 'Installed with Nmap / Wireshark' }))

# Wireshark
$wsPath = Join-Path $env:ProgramFiles 'Wireshark\Wireshark.exe'
if (Test-Path $wsPath) {
    $v = (Get-Item $wsPath).VersionInfo.ProductVersion
    Add-Result 'Wireshark' $true "Version $v"
} else {
    Add-Result 'Wireshark' $false 'Install from https://www.wireshark.org/download.html'
}

# Sysmon
$sysmon = Get-Service Sysmon64 -ErrorAction SilentlyContinue
if (-not $sysmon) { $sysmon = Get-Service Sysmon -ErrorAction SilentlyContinue }
if ($sysmon) {
    $count = 0
    try {
        $count = (Get-WinEvent -LogName 'Microsoft-Windows-Sysmon/Operational' -MaxEvents 1000 -ErrorAction Stop).Count
    } catch { }
    Add-Result 'Sysmon' ($sysmon.Status -eq 'Running') "Service: $($sysmon.Status); recent events: $count"
} else {
    Add-Result 'Sysmon' $false 'Run .\Install-Sysmon.ps1 as Administrator'
}

# Splunk
$splunk = Get-Service Splunkd -ErrorAction SilentlyContinue
Add-Result 'Splunk Enterprise' ($null -ne $splunk) ($(if ($splunk) { "Service: $($splunk.Status) - http://localhost:8000" } else { 'Install from splunk.com' }))

$results | Format-Table -AutoSize
