# 🛡️ SOC Home Lab — Learning Journey

My hands-on journey through cybersecurity tools, from **attacker (Red)** to **defender (Blue)**, ending in **Splunk detections**.

Everything here was done on my own laptop and home network.

> ⚠️ **Legal note:** Only scan or test devices and networks you own or have written permission to test.

---

## 🗺️ Learning Path & Progress

| # | Topic | Tool | Status | Notes |
|---|---|---|---|---|
| 0 | Tools landscape (90 tools) | — | ✅ Done | [docs/00-tools-landscape.md](docs/00-tools-landscape.md) |
| 1 | Cybersecurity basic concepts | — | ✅ Done | [docs/01-basic-concepts.md](docs/01-basic-concepts.md) |
| 2 | Red, Blue & Purple teams | — | ✅ Done | [docs/02-red-blue-purple.md](docs/02-red-blue-purple.md) |
| 3 | Network scanning | Nmap | ✅ Done | [docs/03-nmap.md](docs/03-nmap.md) |
| 4 | Packet analysis | Wireshark | ✅ Done | [docs/04-wireshark.md](docs/04-wireshark.md) |
| 5 | Windows endpoint logging | Sysmon | ✅ Done | [docs/05-sysmon.md](docs/05-sysmon.md) |
| 6 | Decoding attacker commands | CyberChef | ✅ Done | [docs/06-cyberchef.md](docs/06-cyberchef.md) |
| 7 | Detection in SIEM | Splunk | ▶️ In progress | [docs/07-splunk-detection.md](docs/07-splunk-detection.md) |
| 8 | Attack simulation | Atomic Red Team | ⏳ Next | — |
| 9 | Detection rules as code | Sigma | ⏳ Planned | — |

---

## 🔁 The Big Picture

```
 🔴 ATTACK            🔵 SEE IT                    🟢 DETECT IT
 Nmap scan      →     Wireshark (network)    →     Splunk alert
 Encoded PS     →     Sysmon (endpoint)      →     Splunk alert
                      CyberChef (decode)
```

---

## 📦 What's in this repo

| Folder | Contents |
|---|---|
| [`docs/`](docs/) | Step-by-step notes for every lesson |
| [`scripts/`](scripts/) | PowerShell scripts to set up and run the lab |
| [`splunk/soc_home_lab/`](splunk/soc_home_lab/) | Splunk app: Sysmon input, detections, dashboard |
| [`build.sh`](build.sh) | Packages the Splunk app as an installable `.spl` file |

### Quick start (Windows, PowerShell as Administrator)

```powershell
# 1. Check which lab tools are installed
.\scripts\Check-LabTools.ps1

# 2. Install Sysmon with the SwiftOnSecurity config
.\scripts\Install-Sysmon.ps1 -SysmonFolder "D:\sysmon\Sysmon"

# 3. Run the harmless "encoded PowerShell" attack simulation
.\scripts\Invoke-EncodedPowerShellDemo.ps1

# 4. See what Sysmon recorded
.\scripts\Get-SysmonEvents.ps1 -EventId 1 -Last 10
```

### Install the Splunk app
1. Download `soc_home_lab.spl` from [Releases](../../releases) (or run `./build.sh`)
2. Splunk → **Apps → Manage Apps → Install app from file**
3. Install the **Splunk Add-on for Sysmon** from Splunkbase too
4. Restart Splunk

---

## 👤 About

**Syed Abuthahir** — SIEM Consultant & SOC / Security Automation Engineer
Splunk Enterprise Certified Architect · 10+ years across Splunk, QRadar, LogRhythm and SOAR.
