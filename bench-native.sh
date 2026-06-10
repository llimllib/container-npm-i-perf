#!/bin/bash
# Benchmark: native npm install (cold cache via temp dir)
# Cleanup is handled by hyperfine --prepare
set -e
npm install --no-audit --no-fund --cache /tmp/npm-bench-cache 2>/dev/null
