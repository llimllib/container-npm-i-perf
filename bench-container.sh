#!/bin/bash
# Benchmark: Apple container npm install on mounted volume
# Cleanup is handled by hyperfine --prepare
set -e
container run --rm \
  -v "$(pwd):/app" \
  -w /app \
  "${IMAGE}" \
  sh -c "npm install --no-audit --no-fund 2>/dev/null"
