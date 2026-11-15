# 04 · Wireshark — Watching the Attack 🔵

| Nmap 🔴 | Wireshark 🔵 |
|---|---|
| **Sends** knocks | **Records** all traffic |
| Explore / attack | Watch / investigate |
| A person knocking on doors | A CCTV camera on the street |

## Install
- https://www.wireshark.org/download.html → **Windows x64 Installer** (stable, e.g. `4.6.x`)
- Avoid `rc` (test), `arm64`, `pdb`, `Portable`, `Stratoshark` builds
- **USBPcap:** leave unchecked (not needed)

## Lab — Capture my own Nmap scan
1. Wireshark → double-click **Wi-Fi** (the adapter with the moving wave line)
2. Command Prompt → `nmap 192.168.0.1`
3. Stop capture (red ■)
4. Apply display filters (top bar, not Command Prompt):

### Filter 1 — Nmap's knocks
```
ip.dst == 192.168.0.1 && tcp.flags.syn == 1
```
What I saw:
- Same source → same target on every line (`192.168.0.14 → 192.168.0.1`)
- **Different destination port on every line** (32, 2170, 3211, 7741, 9500…)
- Hundreds of packets in **milliseconds** → a tool, not a human
- Repeated ports = **retransmissions** to filtered ports
- **`Win=1024`** on every SYN → classic **Nmap fingerprint** (normal browser SYN: `Win=65535`)
- Source port barely changes (48375 / 48377)

### Filter 2 — Router's "closed" answers
```
ip.src == 192.168.0.1 && tcp.flags.reset == 1
```
- `[RST, ACK]` from ports 445, 8008, 49153… = **closed** — matches Nmap's output
- Red rows = Wireshark's colour for resets (not a danger flag)

## Nmap result ↔ packet evidence
| Nmap says | Wireshark shows |
|---|---|
| open | `[SYN, ACK]` reply |
| closed | `[RST, ACK]` reply |
| filtered | no reply (Nmap retries) |

## Packet layers (bottom pane)
| Layer | Shows |
|---|---|
| Frame | Whole packet (54 bytes) |
| Ethernet II | MAC addresses (router `TaicangT&W` → laptop `Intel`) |
| IP | `192.168.0.1 → 192.168.0.14` |
| TCP | Ports `445 → 48373` |

## 🔵 SOC takeaway
> **Port scan = 1 source IP → 1 target → many different ports → in seconds**

That is exactly what Splunk/Suricata/Zeek port-scan detections look for.

## Normal traffic seen (for comparison)
QUIC (Google), DNS queries, TLS application data, a single SYN to 443 per website.
