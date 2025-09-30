#!/bin/bash
# Simple script for configure fail2ban with abuseip for SSH protection
set -euo pipefail

# Install fail2ban (Debian/Ubuntu-based)
apt update
apt install fail2ban -y

JAIL_LOCAL="/etc/fail2ban/jail.local"
ABUSE_CONF="/etc/fail2ban/action.d/abuseipdb.conf"

# Ask for AbuseIPDB API key
read -r -p "Enter AbuseIPDB API key (or 'no' to disable): " ABUSE_API
ABUSE_API="${ABUSE_API## }"   # trim leading spaces
ABUSE_API="${ABUSE_API%% }"   # trim trailing spaces
lower_api="$(printf '%s' "$ABUSE_API" | tr '[:upper:]' '[:lower:]')"

# If no API or user entered "no"
if [ -z "$ABUSE_API" ] || [ "$lower_api" = "no" ]; then
    # Configure jail.local with a simple SSHD section (no AbuseIPDB)
    cat > "$JAIL_LOCAL" <<'EOF'
[sshd]

enabled = true
port    = ssh
backend = systemd
maxretry = 2
findtime = 300
bantime = 15m
ignoreip = 127.0.0.1
EOF
else
    # Configure jail.local with SSHD + AbuseIPDB integration
    cat > "$JAIL_LOCAL" <<EOF
[sshd]

enabled = true
port    = ssh
backend = systemd
maxretry = 2
findtime = 300
bantime = 15m
ignoreip = 127.0.0.1
action = %(action_)s
         %(action_abuseipdb)s[abuseipdb_apikey="${ABUSE_API}", abuseipdb_category="18,22"]
EOF

    # Replace the AbuseIPDB API key in abuseipdb.conf
    sed -i "s|^abuseipdb_apikey[[:space:]]*=[[:space:]]*.*|abuseipdb_apikey = ${ABUSE_API}|" "$ABUSE_CONF"

    # Replace the actionban line in abuseipdb.conf
    NEW_ACTIONBAN='actionban = lgm=$(printf "%.1000s\n..." "<matches>"); curl -sSf "https://api.abuseipdb.com/api/v2/report" -H "Accept: application/json" -H "Key: <abuseipdb_apikey>" --data-urlencode "comment=Brute-force SSH server detected by Fail2ban" --data-urlencode "ip=<ip>" --data "categories=<abuseipdb_category>"'
    sed -i "0,/^actionban =/s|^actionban =.*|${NEW_ACTIONBAN}|" "$ABUSE_CONF"
fi

# Restart fail2ban to apply changes
systemctl restart fail2ban
