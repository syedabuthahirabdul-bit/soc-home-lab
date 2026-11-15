# 01 · Cybersecurity Basic Concepts

Explained with everyday examples 🏠

## 1. CIA Triad — the 3 goals of security
| Goal | Meaning | Example |
|---|---|---|
| **Confidentiality** | Only the right people can **see** it | A locked diary |
| **Integrity** | Nobody can **change** it secretly | Nobody can change ₹1,000 to ₹10,000 in your bank account |
| **Availability** | It **works** when needed | The ATM gives money when you need it |

## 2. Vulnerability, Threat, Risk
- **Vulnerability** = weak spot → a broken window
- **Threat** = someone who can use it → a thief in the area
- **Risk** = chance of harm → broken window + thief = high risk

## 3. Authentication vs Authorization
- **Authentication** = *Who are you?* → ID card at the gate (password, OTP, fingerprint)
- **Authorization** = *What can you do?* → your card opens your floor, not the server room
- **MFA** = more than one proof (password + OTP)

## 4. Least Privilege
Give only the access needed. The cleaner gets the door key, not the locker key.

## 5. Defense in Depth
Many layers: Firewall → EDR → Passwords + MFA → **SIEM watching everything**.

## 6. Encryption
Turns data into secret code only the key holder can read (🔒 HTTPS).

## 7. Common Attacks
| Attack | Meaning |
|---|---|
| Phishing | Fake email/SMS that tricks you |
| Virus | Spreads by attaching to files |
| Ransomware | Locks files, demands money |
| Trojan | Looks good, is bad inside |
| Brute force | Guessing passwords repeatedly |
| DDoS | Flooding a site until it crashes |

## 8. Firewall
A security guard at the gate that allows or blocks traffic.

## 9. Incident Response
1. **Detect** → alarm (Splunk alert)
2. **Contain** → isolate the PC
3. **Eradicate** → remove the malware
4. **Recover** → back to normal
5. **Lessons learned** → fix how they got in

## Where SOC roles fit
- **SIEM** (Splunk/QRadar) = CCTV control room
- **SOC** = people watching the CCTV
- **SOAR** (Tines) = robot assistant automating repeat tasks
