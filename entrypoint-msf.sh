#!/usr/bin/env bash
set -euo pipefail

# Optional Tor
if [ "${ENABLE_TOR}" = "true" ]; then
  mkdir -p /etc/tor
  cat >/etc/tor/torrc <<EOF
SocksPort ${TOR_SOCKS_ADDR}:${TOR_SOCKS_PORT}
CookieAuthentication 0
Log notice stdout
EOF
  tor -f /etc/tor/torrc >/var/log/tor.log 2>&1 &
fi

# Auto-detect Metasploit install dir for sqlmap
if [ -z "${SQLMAP_MSF_PATH}" ]; then
  if command -v msfconsole >/dev/null 2>&1; then
    CANDIDATES=(
      "$(dirname \"$(realpath \"$(command -v msfconsole)\")\")/.."
      "/opt/metasploit-framework"
      "/usr/share/metasploit-framework"
      "/usr/lib/metasploit-framework"
    )
    for p in "${CANDIDATES[@]}"; do
      if [ -d "$p" ]; then export SQLMAP_MSF_PATH="$p"; break; fi
    done
  fi
fi

# Optional msfrpcd (disabled by default)
if [ "${AUTO_START_MSF_RPC}" = "true" ]; then
  nohup msfrpcd -U "$MSF_RPC_USER" -P "$MSF_RPC_PASS" -p "$MSF_RPC_PORT" -n -f \
    >/var/log/msfrpcd.log 2>&1 &
fi

# Pass --msf-path to sqlmap if available (unless already provided)
ARGS=("$@")
if [ -n "${SQLMAP_MSF_PATH}" ]; then
  if [[ " ${ARGS[*]} " != *" --msf-path "* ]]; then
    ARGS=(--msf-path "$SQLMAP_MSF_PATH" "${ARGS[@]}")
  fi
fi

exec uv run ./sqlmap.py "${ARGS[@]}"


