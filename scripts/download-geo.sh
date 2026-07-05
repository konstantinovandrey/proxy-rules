#!/usr/bin/env bash
set -euo pipefail

# Download latest geoip/geosite databases
# Run weekly via cron or GitHub Actions

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DIST_DIR="$ROOT_DIR/dist"

mkdir -p "$DIST_DIR/sing-box" "$DIST_DIR/v2ray"

echo "📥 Downloading latest geo databases..."

# Sing-box format (recommended — single-file geoip.db / geosite.db)
echo "  → sing-box/geoip.db"
curl -fL -o "$DIST_DIR/sing-box/geoip.db" \
    "https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db"

echo "  → sing-box/geosite.db"
curl -fL -o "$DIST_DIR/sing-box/geosite.db" \
    "https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db"

# v2ray / Xray format
echo "  → v2ray/geoip.dat"
curl -fL -o "$DIST_DIR/v2ray/geoip.dat" \
    "https://github.com/v2fly/geoip/releases/latest/download/geoip.dat"

echo "  → v2ray/geosite.dat"
curl -fL -o "$DIST_DIR/v2ray/geosite.dat" \
    "https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat"

echo ""
echo "✅ Geo databases updated"
echo "   sing-box: geoip.db + geosite.db"
echo "   v2ray:    geoip.dat + geosite.dat"
