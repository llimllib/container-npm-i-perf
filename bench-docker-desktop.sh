#!/bin/bash
# Benchmark: Docker Desktop npm install on mounted volume
# Cleanup is handled by hyperfine --prepare
set -e
docker --context desktop-linux run --rm \
  -v "$(pwd):/app" \
  -w /app \
  "${IMAGE}" \
  sh -c "npm install --no-audit --no-fund 2>/dev/null"
