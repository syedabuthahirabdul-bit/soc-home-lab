# 03 · Nmap — Network Scanning 🔴

**Nmap (Network Mapper)** knocks on every door of a network and reports:
1. Which devices are **ON**
2. Which **ports** (doors) are open
3. Which **software** is behind each port

> ⚠️ Only scan networks you own. `scanme.nmap.org` is an official practice target.

## Install (Windows)
1. https://nmap.org/download → **Windows** → `nmap-x.xx-setup.exe`
2. Accept defaults. Also install **Npcap** (keep *WinPcap API-compatible mode* checked).
3. Verify: `nmap --version`

---

## Lab 1 — Scan my own PC
```
nmap 127.0.0.1
```
```
PORT    STATE SERVICE
135/tcp open  msrpc
445/tcp open  microsoft-ds
```
- 998 ports closed, 2 open — **normal for Windows**
- **445 = SMB** (file sharing) — famous because **WannaCry (2017)** spread through it

## Lab 2 — Version detection
```
nmap -sV 127.0.0.1
```
- Adds a **VERSION** column (e.g. `Microsoft Windows RPC`)
- `?` after a service = Nmap is **not 100% sure**
- Why it matters: versions → known vulnerabilities (CVEs)

## Lab 3 — Find my network (`ipconfig`)
| Field | Value | Meaning |
|---|---|---|
| IPv4 Address | `192.168.0.14` | My laptop |
| Default Gateway | `192.168.0.1` | My router |
| Subnet Mask | `255.255.255.0` | Network = `192.168.0.0/24` |

**Private IP ranges** (inside networks only):
`192.168.x.x` (home) · `10.x.x.x` (companies) · `172.16–31.x.x`

### ❌ Lesson: false positives
Scanning the **wrong** range (`192.168.1.0/24`) reported **256/256 hosts up** — impossible
(`.0` and `.255` are never real devices). There were **no MAC addresses**, proving the range
wasn't my local network: a device on the path answered for everything.
👉 *Always check if a result makes sense — same as validating a Splunk alert.*

## Lab 4 — Discover all devices
```
nmap -sn -T4 192.168.0.0/24
```
| IP | Vendor (from MAC) | Device |
|---|---|---|
| 192.168.0.1 | Taicang T&W Electronics | 📡 Router (GPON fiber) |
| 192.168.0.14 | — | 💻 My laptop |
| 192.168.0.18 | Hon Hai (Foxconn) | 📺 Smart TV / Chromecast |
| .2 / .5 / .7 / .53 | Unknown | 📱 Phones (random MACs) |

**Random MACs:** if the 2nd character of a MAC is **2, 6, A or E**, it's a randomized
(privacy) address — typical for modern phones.

Useful variants:
```
nmap -sn -T4 192.168.0.0/24 | findstr "hosts up"     # count only
nmap -sn -T4 192.168.0.0/24 | findstr "report MAC"   # list only
```

## Lab 5 — Scan the router
```
nmap -sV -T4 192.168.0.1
```
| Port | State | Real service |
|---|---|---|
| 80, 443 | open | Router web login (`GPON Home Gateway`, `thttpd`) |
| 445, 8008, 49155, 49160 | closed | Nothing listening |
| 994 others | **filtered** | Firewall silently drops ✅ |

- Nmap labelled 80/443 as **rtsp** — wrong. The fingerprint showed `<title>GPON Home Gateway</title>`.
  👉 *Never trust the label; read the evidence.*
- Verdict: no Telnet/SSH/FTP exposed, firewall active → **secure**.

### The 3 port states
| State | Meaning | House |
|---|---|---|
| open | Service answers | Door open, someone says hello |
| closed | Reachable, nothing listening | "Nobody here!" |
| filtered | Firewall drops it | Total silence |

## Lab 6 — Identify the mystery device
```
nmap -sV -T4 192.168.0.18
```
`8008`, `8009 castv2`, `8443`, `9000` → **Google Cast** → Smart TV / Chromecast.
Tip: put IoT devices on a **guest Wi-Fi**.

## Cheat sheet
| Command | Purpose |
|---|---|
| `nmap <ip>` | Top 1000 ports |
| `nmap -sV <ip>` | + service versions |
| `nmap -sn <range>` | Host discovery only |
| `nmap -p 80,443 <ip>` | Specific ports |
| `-T4` | Faster timing |
