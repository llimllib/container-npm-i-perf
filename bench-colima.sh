#!/bin/bash
# Benchmark: colima (vz backend + virtiofs) npm install on mounted volume
# Cleanup is handled by hyperfine --prepare
set -e
docker --context colima run --rm \
  -v "$(pwd):/app" \
  -w /app \
  "${IMAGE}" \
  sh -c "npm install --no-audit --no-fund 2>/dev/null"
