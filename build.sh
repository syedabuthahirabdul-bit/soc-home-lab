#!/usr/bin/env bash
# Packages the Splunk app as dist/soc_home_lab.spl (a .tar.gz Splunk can install).
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p dist
tar --exclude='.DS_Store' -czf dist/soc_home_lab.spl -C splunk soc_home_lab
echo "Built dist/soc_home_lab.spl"
