# 05 · Sysmon — CCTV Inside Windows 🔵

**Sysmon** (Microsoft Sysinternals) records detailed Windows activity:
which programs run, with what command line, which connections they make.

- **Wireshark** = CCTV on the **network**
- **Sysmon** = CCTV **inside the computer**

## Install
1. Download: https://learn.microsoft.com/sysinternals/downloads/sysmon → extract (e.g. `D:\sysmon\Sysmon`)
2. Config: https://github.com/SwiftOnSecurity/sysmon-config → `sysmonconfig-export.xml` → same folder
3. **PowerShell as Administrator** (prompt starts at `C:\Windows\system32`):
```powershell
cd D:\sysmon\Sysmon
.\Sysmon64.exe -accepteula -i sysmonconfig-export.xml
```
Or use [`scripts/Install-Sysmon.ps1`](../scripts/Install-Sysmon.ps1).

### Errors I hit (and fixes)
| Error | Cause | Fix |
|---|---|---|
| `'sysmon64.exe' is not recognized` | PowerShell doesn't run files from the current folder | Prefix with **`.\`** |
| `You need to launch Sysmon as an Administrator` | Not elevated | Run PowerShell **as Administrator** |

Success:
```
Sysmon64 installed.
SysmonDrv started.
Sysmon64 started.
```

## View the logs
Event Viewer →
```
Applications and Services Logs → Microsoft → Windows → Sysmon → Operational
```
Or PowerShell:
```powershell
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 5
```

## Key Event IDs
| ID | Meaning | Key fields |
|---|---|---|
| **1** | Process Create | Image, CommandLine, User, ParentImage |
| **3** | Network Connection | Image, DestinationIp, DestinationPort |
| 11 | File Create | TargetFilename |
| 22 | DNS Query | QueryName |

Filter in Event Viewer: **Filter Current Log… → Event IDs: `1`**

## Lab — Find Nmap
```
Image:        C:\Program Files (x86)\Nmap\nmap.exe
CommandLine:  nmap 192.168.0.1
ParentImage:  C:\Windows\System32\cmd.exe
```

### 💡 Why Nmap's 1000 knocks don't show as Event ID 3
Nmap sends raw packets through **Npcap**, bypassing the normal Windows network stack
that Sysmon watches. That's why a SOC needs **both**:
- **Sysmon** → *who ran nmap.exe* (endpoint)
- **Network logs / IDS** → *the scan itself* (network)
