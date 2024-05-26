#!/usr/bin/env sh
set -e

tor -f /etc/tor/torrc &

# Wait for Tor SOCKS port to be available
for i in $(seq 1 30); do
  if python - <<'PY'
import socket
s = socket.socket()
try:
    s.settimeout(1)
    s.connect(("127.0.0.1", 9050))
    print("ready")
except Exception:
    pass
finally:
    s.close()
PY
  then
    break
  fi
  sleep 1
done

exec python ./sqlmap.py "$@"