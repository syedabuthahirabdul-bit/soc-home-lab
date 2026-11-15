# Useful Resources & Credits

Community projects I use in this lab. All credit to their authors — follow the links for the originals.

## livehybrid (William Searle, SplunkTrust)
| Project | What it's for |
|---|---|
| [downloadSplunk](https://github.com/livehybrid/downloadSplunk) · [web version](https://livehybrid.github.io/downloadSplunk/) | Direct download links for current and older Splunk Enterprise / UF versions. My [`Get-SplunkInstaller.ps1`](../scripts/Get-SplunkInstaller.ps1) reads its version list live. |
| [splunk_drawio_icons](https://github.com/livehybrid/splunk_drawio_icons) | Splunk icons for draw.io architecture diagrams |
| [splunk_boilerplate_app](https://github.com/livehybrid/splunk_boilerplate_app) | Example CI/CD pipeline for building Splunk apps at scale |
| [regulator](https://github.com/livehybrid/regulator) | Search load generation / performance testing for Splunk |
| [dashpub-plus](https://github.com/livehybrid/dashpub-plus) | Publish Splunk dashboards outside Splunk with a Redis cache |
| [splunk-knowledge-mapper](https://github.com/livehybrid/splunk-knowledge-mapper) | Splunk app for visualizing connected data |

## Lab tools
| Project | Link |
|---|---|
| Nmap | https://nmap.org |
| Wireshark | https://www.wireshark.org |
| Sysmon | https://learn.microsoft.com/sysinternals/downloads/sysmon |
| SwiftOnSecurity sysmon-config | https://github.com/SwiftOnSecurity/sysmon-config |
| CyberChef | https://gchq.github.io/CyberChef |
| Atomic Red Team | https://github.com/redcanaryco/atomic-red-team |
| Sigma | https://github.com/SigmaHQ/sigma |

## Downloading Splunk
```powershell
.\scripts\Get-SplunkInstaller.ps1 -List                     # see all versions
.\scripts\Get-SplunkInstaller.ps1                           # latest Enterprise for Windows
.\scripts\Get-SplunkInstaller.ps1 -Version 10.2.4           # specific version
.\scripts\Get-SplunkInstaller.ps1 -Product uf -Platform linux -Format deb
```
Installers are downloaded from **download.splunk.com** and are not stored in this repo
(Splunk's license doesn't allow redistribution, and they exceed GitHub's file size limit).

### How older-version links work
Splunk files live at a predictable URL — but each release has a unique **build ID** you can't guess:
```
https://download.splunk.com/products/<splunk|universalforwarder>/releases/<version>/<os>/<file>
e.g. .../universalforwarder/releases/6.3.0/windows/splunkforwarder-6.3.0-aa7d4b1ccb80-x64-release.msi
```
- Discussion: [Splunk Community — Where is the Splunk Forwarder older versions page?](https://community.splunk.com/t5/Installation/Where-is-the-Splunk-Forwarder-older-versions-page/m-p/236089)
- Official (login required): https://www.splunk.com/page/previous_releases/universalforwarder
- livehybrid's list collects the build IDs, and `Get-SplunkInstaller.ps1` uses it to build the link automatically.
