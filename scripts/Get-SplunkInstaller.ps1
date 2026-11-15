<#
.SYNOPSIS
    Lists or downloads any Splunk Enterprise / Universal Forwarder installer
    directly from Splunk's official server (download.splunk.com).

.DESCRIPTION
    The version/build list is read live from the community downloadSplunk project
    by William Searle (livehybrid): https://github.com/livehybrid/downloadSplunk
    Files are always downloaded from download.splunk.com - nothing is re-hosted.

    You are bound by Splunk's license terms for any software you download.
    Old versions may be unsupported and contain known vulnerabilities.

.EXAMPLE
    .\Get-SplunkInstaller.ps1 -List                                   # all Enterprise versions
    .\Get-SplunkInstaller.ps1 -List -Product uf                       # all Universal Forwarder versions
    .\Get-SplunkInstaller.ps1                                         # latest Enterprise, Windows .msi
    .\Get-SplunkInstaller.ps1 -Version 10.2.4                         # a specific version
    .\Get-SplunkInstaller.ps1 -Product uf -Version 9.4.5 -Platform linux -Format deb
    .\Get-SplunkInstaller.ps1 -Version 10.2.4 -UrlOnly                # just print the link
#>
param(
    [ValidateSet('enterprise', 'uf')] [string] $Product = 'enterprise',
    [string] $Version = 'latest',
    [ValidateSet('windows', 'linux', 'osx')] [string] $Platform = 'windows',
    [ValidateSet('msi', 'zip', 'deb', 'rpm', 'tgz', 'dmg')] [string] $Format = 'msi',
    [ValidateSet('x64', 'arm64')] [string] $Arch = 'x64',
    [string] $OutFolder = (Join-Path $env:USERPROFILE 'Downloads'),
    [switch] $List,
    [switch] $UrlOnly
)

$ErrorActionPreference = 'Stop'
$listUrl  = 'https://livehybrid.github.io/downloadSplunk/downloads.tsv'
$baseUrl  = 'https://download.splunk.com/products'
$prodKey  = if ($Product -eq 'uf') { 'universalforwarder' } else { 'splunk' }

Write-Verbose "Reading version list from $listUrl"
$rows = (Invoke-WebRequest -Uri $listUrl -UseBasicParsing).Content -split "`n" |
    Where-Object { $_ -and -not $_.StartsWith('#') } |
    ForEach-Object {
        $c = $_.Trim() -split "`t"
        if ($c.Count -ge 4) {
            [pscustomobject]@{ Product = $c[0]; Version = $c[1]; Build = $c[2]; Paths = $c[3] -split ' ' }
        }
    } |
    Where-Object { $_.Product -eq $prodKey }

if (-not $rows) { throw "No versions found for product '$prodKey'." }

function ConvertTo-SortableVersion($v) {
    $p = ($v -split '\.') + @('0', '0', '0', '0') | Select-Object -First 4
    [version]($p -join '.')
}
$rows = $rows | Sort-Object { ConvertTo-SortableVersion $_.Version } -Descending

if ($List) {
    $rows | Select-Object Version, Build, @{ n = 'Files'; e = { $_.Paths.Count } } | Format-Table -AutoSize
    return
}

$row = if ($Version -eq 'latest') { $rows | Select-Object -First 1 } else { $rows | Where-Object Version -eq $Version }
if (-not $row) { throw "Version '$Version' not found. Run with -List to see available versions." }

# Pick the file matching platform / format / architecture
$folders = @{ windows = 'windows'; linux = 'linux'; osx = 'osx' }
$candidates = $row.Paths | Where-Object { $_ -like "$($folders[$Platform])/*" -and $_ -like "*.$Format" }
$archPattern = if ($Arch -eq 'arm64') { '(arm64|aarch64)' } else { '(x64|x86_64|amd64|-64)' }
$match = $candidates | Where-Object { $_ -match $archPattern } | Select-Object -First 1
if (-not $match) { $match = $candidates | Select-Object -First 1 }
if (-not $match) {
    Write-Host "No $Platform .$Format file for $Product $($row.Version). Available files:" -ForegroundColor Yellow
    $row.Paths | ForEach-Object { "  $_" }
    return
}

$url  = "$baseUrl/$prodKey/releases/$($row.Version)/$match"
$file = Join-Path $OutFolder (Split-Path $match -Leaf)

Write-Host "Product : $Product $($row.Version) (build $($row.Build))"
Write-Host "URL     : $url"
if ($UrlOnly) { return }

if (-not (Test-Path $OutFolder)) { New-Item -ItemType Directory -Path $OutFolder | Out-Null }
Write-Host "Saving  : $file"

if (Get-Command Start-BitsTransfer -ErrorAction SilentlyContinue) {
    Start-BitsTransfer -Source $url -Destination $file -DisplayName "Splunk $($row.Version)"
} else {
    $ProgressPreference = 'SilentlyContinue'   # makes Invoke-WebRequest much faster
    Invoke-WebRequest -Uri $url -OutFile $file -UseBasicParsing
}

# Verify against the official SHA512 that Splunk publishes next to every file
$hash = (Get-FileHash $file -Algorithm SHA512).Hash.ToLower()
try {
    $official = (Invoke-WebRequest -Uri "$url.sha512" -UseBasicParsing).Content
    $official = ([regex]::Match([string]$official, '[0-9a-fA-F]{128}')).Value.ToLower()
} catch { $official = $null }

if (-not $official) {
    Write-Host "Downloaded. Could not fetch $url.sha512 to verify - check it manually." -ForegroundColor Yellow
    Write-Host "SHA512: $hash"
} elseif ($hash -eq $official) {
    Write-Host "Done. SHA512 matches Splunk's official checksum - file is genuine." -ForegroundColor Green
} else {
    Write-Host "WARNING: SHA512 does NOT match Splunk's checksum. Do not install this file." -ForegroundColor Red
    Write-Host "Expected: $official"
    Write-Host "Got     : $hash"
}
