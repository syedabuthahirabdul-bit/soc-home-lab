# 07 · Splunk — Detecting the Attacks 🟢

*Status: in progress*

Goal: send Sysmon logs to Splunk and alert automatically on what I found by hand.

## 1. Install Splunk Enterprise (Windows)
- splunk.com → Free Trials & Downloads → Splunk Enterprise → Windows `.msi`
- 60-day trial, then Free license (500 MB/day) — enough for a lab
- Open http://localhost:8000

## 2. Add-on
Splunkbase → **Splunk Add-on for Sysmon** (field extractions & CIM mapping)

## 3. Collect Sysmon
Install this repo's app ([`splunk/soc_home_lab`](../splunk/soc_home_lab)) or add manually to
`%SPLUNK_HOME%\etc\system\local\inputs.conf`:
```ini
[WinEventLog://Microsoft-Windows-Sysmon/Operational]
disabled = 0
renderXml = true
index = main
```
Restart Splunk.

## 4. Verify data
```spl
index=main source="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational"
| stats count by EventCode
```

## 5. Detections (included in the app)
| Saved search | Catches |
|---|---|
| `SOC Lab - Encoded PowerShell` | `powershell.exe` with `-enc` / `-EncodedCommand` |
| `SOC Lab - Nmap Execution` | `nmap.exe` process creation |
| `SOC Lab - Sysmon Event Volume` | Event counts by ID (health check) |

### Encoded PowerShell
```spl
index=main source="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
  Image="*\\powershell.exe"
  (CommandLine="*-enc*" OR CommandLine="*-EncodedCommand*")
| table _time, host, User, ParentImage, Image, CommandLine
```

### Nmap execution
```spl
index=main source="XmlWinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
  Image="*\\nmap.exe"
| table _time, host, User, ParentImage, CommandLine
```

## Next
- Decode the Base64 automatically in SPL
- Map detections to MITRE ATT&CK (T1059.001, T1046)
- Test with **Atomic Red Team**
