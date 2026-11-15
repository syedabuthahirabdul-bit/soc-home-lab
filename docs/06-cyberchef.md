# 06 · CyberChef — Decoding Attacker Commands 🔍

**CyberChef** (by GCHQ) turns scrambled text into readable text.
https://gchq.github.io/CyberChef

## Kitchen analogy
- **Ingredient** = scrambled input
- **Recipe** = steps (e.g. *From Base64*)
- **Dish** = readable output

Simple test: `SGVsbG8gU3llZA==` + **From Base64** → `Hello Syed`

Not sure what it is? Click the **Magic wand 🪄**.

---

## Lab — Catch & decode a hidden PowerShell command

### 🔴 1. Attacker: run an encoded command (harmless)
```powershell
powershell -EncodedCommand VwByAGkAdABlAC0ASABvAHMAdAAgACcASABlAGwAbABvACAAUwB5AGUAZAAgAGYAcgBvAG0AIABTAHkAcwBtAG8AbgAgAGwAYQBiACcA
```
Attackers use `-EncodedCommand` so analysts can't read the command at a glance.
Script: [`scripts/Invoke-EncodedPowerShellDemo.ps1`](../scripts/Invoke-EncodedPowerShellDemo.ps1)

### 🔵 2. Defender: find it in Sysmon (Event ID 1)
```
Image:        ...\powershell.exe
CommandLine:  powershell -EncodedCommand VwByAGkA...
```
🚨 `-EncodedCommand` / `-enc` is a classic **red flag**.

### 🔍 3. Investigate: decode in CyberChef
Recipe:
1. **From Base64**
2. **Decode text → UTF-16LE (1200)**

Output:
```
Write-Host 'Hello Syed from Sysmon lab'
```
Why UTF-16LE? PowerShell's `-EncodedCommand` is Base64 of **UTF-16LE** text.

### ✅ 4. Verdict: harmless (lab test)

## SOC investigation flow
**Alert** → **Logs** (Sysmon EID 1) → **Decode** (CyberChef) → **Verdict**

## Handy Base64 prefixes
| Starts with | Is |
|---|---|
| `TVqQ` | Windows EXE |
| `H4sI` | gzip |
| `UEsD` | ZIP / Office doc |
| `JVBER` | PDF |
| `SQBFAFgA` | `IEX` in UTF-16LE (PowerShell) |

> 💡 For client data, use the **offline** CyberChef HTML — never paste sensitive data into public sites.
