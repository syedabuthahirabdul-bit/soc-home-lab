# 02 · Red, Blue & Purple Teams

## The game: Thief and Police (திருடன் போலீஸ்)

| Team | Role | In a company |
|---|---|---|
| 🔴 **Red** | **Thief** (friendly, hired to test) | Attacks the company with permission: phishing, password theft, taking over servers |
| 🔵 **Blue** | **Police** | Defends and detects: watches Splunk alerts, investigates, blocks |
| 🟣 **Purple** | **Thief + Police as friends** | Test together: *"I ran this attack — did Splunk alert?"* If not, fix the detection |

## Why Purple matters
- **Without Purple:** Red writes a report weeks later — *"we hacked you 10 ways"*.
- **With Purple:** each attack is tested live and each missing alert is fixed immediately.

## In one sentence
Red **breaks in**, Blue **catches**, Purple **teaches Blue to catch better, using Red's attacks**.

## In this lab
I play both sides:
- 🔴 Run Nmap / encoded PowerShell
- 🔵 Watch it in Wireshark / Sysmon
- 🟢 Detect it in Splunk
