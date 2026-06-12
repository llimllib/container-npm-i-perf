#!/bin/bash
# Run the full benchmark suite with hyperfine
# Cleanup runs in --prepare so rm -rf is NOT timed
set -e
cd /Users/llimllib/code/container-perf-test

printf "| software | version |\n"
printf "|:---|:---|\n"
printf "| node | %s |\n" "$(node --version)"
printf "| npm | %s |\n" "$(npm --version)"
printf "| docker desktop | %s |\n" "$(docker --context desktop-linux version --format '{{.Server.Version}}' 2>/dev/null || echo 'N/A')"
printf "| container | %s |\n" "$(container --version)"
printf "| orb | %s |\n" "$(orb version | tr '\n' ' ')"
printf "| colima | %s |\n" "$(colima --version)"
printf "| hyperfine | %s |\n" "$(hyperfine --version)"
printf "\n\n"

export IMAGE="node:24.16.0-slim"
PREPARE="rm -rf node_modules package-lock.json /tmp/npm-bench-cache && export IMAGE=$IMAGE"
RUNS=5

hyperfine \
  --runs $RUNS \
  --prepare "$PREPARE" \
  --export-markdown results.md \
  --export-json results.json \
  --command-name "docker desktop (volume mount)" \
    "bash bench-docker-desktop.sh" \
  --command-name "apple container (volume mount)" \
    "bash bench-container.sh" \
  --command-name "native (host)" \
    "bash bench-native.sh" \
  --command-name "colima vz+virtiofs (volume mount)" \
    "bash bench-colima.sh" \
  --command-name "orbstack (volume mount)" \
    "bash bench-orbstack.sh"

# Generate results table from results.json
python result-table.py
