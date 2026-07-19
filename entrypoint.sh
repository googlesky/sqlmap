#!/usr/bin/env bash

set -euo pipefail

/etc/init.d/tor start

exec uv run ./sqlmap.py "$@"
