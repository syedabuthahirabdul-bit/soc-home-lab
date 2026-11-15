# 00 · Cybersecurity Tools Landscape (90 tools)

The **Cybersecurity Tools Landscape 2026** poster groups 90 tools into 9 categories.
One line per tool: what it does.

## How it all connects

```
Red / Purple tools  →  create attacks
Blue tools          →  collect telemetry (Sysmon, Zeek, Suricata) → SIEM detects
Threat Intel        →  enriches alerts (usually in SOAR)
DFIR                →  investigates what happened
Cloud / DevSecOps   →  prevents problems before deployment
AI                  →  speeds up every step
```

---

## 01 · Red Team & Penetration Testing — *attack to find weaknesses*
| Tool | What it does |
|---|---|
| **Nmap** | Finds live hosts, open ports and running services |
| Burp Suite | Intercepting proxy for testing web applications |
| Caido | Lightweight modern alternative to Burp |
| Nuclei | Template-based vulnerability scanner |
| Metasploit | Exploitation framework |
| NetExec | Tests Windows/AD protocols at scale (SMB, LDAP, WinRM) |
| BloodHound | Maps Active Directory attack paths as a graph |
| Impacket | Python toolkit for Windows protocols (secretsdump, psexec) |
| Sliver | Open-source command-and-control (C2) framework |
| ffuf | Fast web fuzzer for hidden paths and parameters |

## 02 · Blue Team & SOC Operations — *collect, detect, investigate*
| Tool | What it does |
|---|---|
| Wazuh | Open-source SIEM / XDR |
| Security Onion | Network security monitoring distro |
| Velociraptor | Endpoint forensics and hunting at scale (VQL) |
| Zeek | Turns network traffic into rich logs |
| Suricata | Network IDS/IPS with signatures |
| **Wireshark** | Captures and inspects network packets |
| **Sysmon** | Detailed Windows endpoint telemetry |
| Sigma | Vendor-neutral detection rule format (→ SPL, KQL, AQL) |
| Chainsaw | Hunts EVTX logs with Sigma rules |
| Hayabusa | Fast Windows event-log timeline generator |

## 03 · Purple Team & Attack Simulation — *test if detections fire*
| Tool | What it does |
|---|---|
| MITRE Caldera | Automated adversary emulation |
| Atomic Red Team | Small single-technique tests mapped to ATT&CK |
| Stratus Red Team | Cloud attack technique simulation |
| VECTR | Tracks purple-team exercises and coverage |
| Infection Monkey | Breach and lateral-movement simulation |
| Prelude Operator | Adversary emulation / control validation |

## 04 · DFIR & Incident Response — *what happened after a compromise*
| Tool | What it does |
|---|---|
| Volatility 3 | Memory forensics |
| Autopsy | Disk image forensics (GUI) |
| KAPE | Fast Windows artifact collection and parsing |
| Eric Zimmerman's Tools | Windows artifact parsers (MFT, prefetch, registry…) |
| Plaso | Builds a "super timeline" from many sources |
| **CyberChef** | Decodes / transforms data (Base64, XOR, gzip…) |
| YARA | Pattern rules to identify malware |
| capa | Lists what a binary can do, mapped to ATT&CK |
| REMnux | Linux distro for malware analysis |

## 05 · Threat Intelligence & OSINT — *enrich IOCs*
| Tool | What it does |
|---|---|
| VirusTotal | Checks hashes, URLs, domains, IPs against 70+ engines |
| Shodan | Search engine for internet-facing devices |
| Censys | Internet asset and certificate discovery |
| urlscan.io | Safely opens a URL and shows what it does |
| ANY.RUN | Interactive malware sandbox |
| MalwareBazaar | Malware sample database |
| OpenCTI | Threat intelligence platform (STIX 2.1) |
| MISP | Threat intel sharing platform |
| SpiderFoot | Automated OSINT |
| theHarvester | Collects emails, subdomains, hosts |

## 06 · Cloud Security & DevSecOps — *catch issues before deployment*
| Tool | What it does |
|---|---|
| Prowler | AWS/Azure/GCP security assessment |
| Trivy | Scans containers, IaC and dependencies |
| Checkov | Finds IaC misconfigurations |
| Semgrep | Static code analysis |
| Gitleaks | Finds secrets committed to Git |
| Falco | Runtime threat detection for containers |
| Kubescape | Kubernetes security assessment |
| OWASP ZAP | Web app security scanner |
| Snyk | Code, dependency, container and IaC scanning |
| Terraform | Infrastructure as code *(not a security tool itself)* |

## 07 · AI-Powered Security Operations
| Tool | What it does |
|---|---|
| Microsoft Security Copilot | AI assistant across Defender / Sentinel |
| Google SecOps (Gemini) | AI hunting and case summaries |
| CrowdStrike Charlotte AI | AI analyst inside Falcon |
| SentinelOne Purple AI | Natural-language threat hunting |
| Splunk ES + AI | AI Assistant (natural language → SPL), AI triage |
| LimaCharlie | API-first SecOps cloud platform |
| ChatGPT / Claude | General LLMs for analysis, scripting, docs |
| Grafana + AI | AI-assisted dashboards |
| Wazuh + OpenAI | DIY LLM enrichment of Wazuh alerts |

## 08 · AI Security Testing & LLM Tools
| Tool | What it does |
|---|---|
| Promptfoo | LLM red teaming and evaluation |
| PyRIT | Microsoft's AI red-teaming framework |
| NVIDIA garak | LLM vulnerability scanner |
| Giskard | ML/LLM testing for bias, hallucination, security |
| LLM Guard | Runtime prompt/output filtering |
| Ollama | Run open models locally |
| Open WebUI | Web UI for local models |
| LangSmith | Trace and evaluate LLM apps |
| DeepChecks | ML/LLM validation and monitoring |
| LlamaIndex | Build RAG apps over your own data |

## 09 · Useful Supporting Tools
| Tool | What it does |
|---|---|
| CyberChef | Decode / analyze data |
| jq / yq | Parse JSON / YAML on the command line |
| tmux | Persistent terminal sessions |
| VS Code | Code editor |
| Docker | Run tools in containers |
| Git | Version control |
| Kali Linux | Pentest distro |
| Ubuntu | General Linux base |
| Proxmox | Hypervisor for home labs |
