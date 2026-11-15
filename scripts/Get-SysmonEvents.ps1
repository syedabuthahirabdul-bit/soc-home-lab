<#
.SYNOPSIS
    Shows recent Sysmon events as a readable table.
.EXAMPLE
    .\Get-SysmonEvents.ps1 -EventId 1 -Last 10
    .\Get-SysmonEvents.ps1 -EventId 1 -Match nmap
    .\Get-SysmonEvents.ps1 -EventId 3 -Last 20
#>
param(
    [int]    $EventId = 1,
    [int]    $Last = 20,
    [string] $Match
)

$log = 'Microsoft-Windows-Sysmon/Operational'
$events = Get-WinEvent -FilterHashtable @{ LogName = $log; Id = $EventId } -MaxEvents 500 -ErrorAction Stop

$rows = foreach ($e in $events) {
    $xml  = [xml]$e.ToXml()
    $data = @{}
    foreach ($d in $xml.Event.EventData.Data) { $data[$d.Name] = $d.'#text' }

    switch ($EventId) {
        1 { [pscustomobject]@{
                Time        = $e.TimeCreated
                User        = $data.User
                Image       = $data.Image
                CommandLine = $data.CommandLine
                ParentImage = $data.ParentImage } }
        3 { [pscustomobject]@{
                Time            = $e.TimeCreated
                Image           = $data.Image
                DestinationIp   = $data.DestinationIp
                DestinationPort = $data.DestinationPort
                Protocol        = $data.Protocol } }
        default { [pscustomobject]@{ Time = $e.TimeCreated; Message = $e.Message.Split("`n")[0] } }
    }
}

if ($Match) {
    $rows = $rows | Where-Object { ($_ | Out-String) -match [regex]::Escape($Match) }
}

$rows | Select-Object -First $Last | Format-List
