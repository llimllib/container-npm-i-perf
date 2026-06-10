#!/bin/bash
# Run the full benchmark suite with hyperfine
# Cleanup runs in --prepare so rm -rf is NOT timed
set -e
cd /Users/llimllib/code/container-perf-test

PREPARE="rm -rf node_modules package-lock.json /tmp/npm-bench-cache"

hyperfine \
  --runs 3 \
  --prepare "$PREPARE" \
  --export-markdown results.md \
  --export-json results.json \
  --command-name "native (host)" \
    "bash bench-native.sh" \
  --command-name "apple container (volume mount)" \
    "bash bench-container.sh" \
  --command-name "colima vz+virtiofs (volume mount)" \
    "bash bench-colima.sh" \
  --command-name "orbstack (volume mount)" \
    "bash bench-orbstack.sh"
