#!/bin/bash
set -e
OPT=/data/options.json
USER_NAME=$(jq -r '.couch_user // "seen"' "$OPT")
USER_PASS=$(jq -r '.couch_password // ""' "$OPT")
TS_KEY=$(jq -r '.tailscale_authkey // ""' "$OPT")
TS_HOST=$(jq -r '.tailscale_hostname // "seen-db"' "$OPT")

if [ -z "$USER_PASS" ] || [ ${#USER_PASS} -lt 10 ]; then
  echo "FEHLER: Bitte in der Konfiguration ein Passwort mit mindestens 10 Zeichen eintragen (couch_password)."
  sleep 300; exit 1
fi

mkdir -p /data/couchdb /data/tailscale /var/run/tailscale
chown -R couchdb:couchdb /data/couchdb

# Tailscale (eigener Knoten nur für die Datenbank, Userspace-Netzwerk, HTTPS-Zertifikat von Tailscale)
tailscaled --tun=userspace-networking --statedir=/data/tailscale --socket=/var/run/tailscale/tailscaled.sock >/dev/null 2>&1 &
TSC="tailscale --socket=/var/run/tailscale/tailscaled.sock"
for i in $(seq 1 30); do $TSC status >/dev/null 2>&1 && break; sleep 1; [ -S /var/run/tailscale/tailscaled.sock ] && break; done
(
  if [ -n "$TS_KEY" ]; then
    $TSC up --authkey="$TS_KEY" --hostname="$TS_HOST" --accept-dns=false
  else
    echo "Tailscale: Falls noch nicht angemeldet, erscheint gleich ein Anmelde-Link – im Browser öffnen und bestätigen."
    $TSC up --hostname="$TS_HOST" --accept-dns=false
  fi
  $TSC serve --bg --https=443 http://127.0.0.1:5984
  echo "SEEN Datenbank erreichbar unter: https://$($TSC status --json | jq -r '.Self.DNSName' | sed 's/\.$//')"
) &

export COUCHDB_USER="$USER_NAME" COUCHDB_PASSWORD="$USER_PASS"
exec tini -- /docker-entrypoint.sh /opt/couchdb/bin/couchdb
