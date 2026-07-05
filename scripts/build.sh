#!/usr/bin/env bash
set -euo pipefail

# Build all rule sets from source YAML
# Requires: sing-box (https://github.com/SagerNet/sing-box)
#   Install: curl -Lo /tmp/sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/latest/download/sing-box-linux-amd64.tar.gz
#            tar -xzf /tmp/sing-box.tar.gz && sudo mv sing-box /usr/local/bin/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
RULES_DIR="$ROOT_DIR/rules"
BUILD_DIR="$ROOT_DIR/build"
DIST_DIR="$ROOT_DIR/dist"

mkdir -p "$BUILD_DIR" "$DIST_DIR/clash" "$DIST_DIR/sing-box" "$DIST_DIR/v2ray"

echo "🔨 Converting YAML → sing-box JSON..."

for rule in direct proxy reject private; do
    python3 -c "
import yaml, json, sys, os
with open('$RULES_DIR/$rule.yaml') as f:
    data = yaml.safe_load(f)
rules = []
for entry in data.get('payload', []):
    parts = entry.split(',', 1)
    if len(parts) != 2:
        continue
    t, v = parts
    r = {}
    if t == 'DOMAIN-SUFFIX':      r['domain_suffix'] = [v]
    elif t == 'DOMAIN':           r['domain'] = [v]
    elif t == 'DOMAIN-KEYWORD':   r['domain_keyword'] = [v]
    elif t == 'IP-CIDR':          r['ip_cidr'] = [v]
    elif t == 'IP-CIDR6':         r['ip_cidr'] = [v]
    # GEOSITE/GEOIP are resolved at runtime via geo databases; skip
    else:                         continue
    rules.append(r)
with open('$BUILD_DIR/$rule.json', 'w') as f:
    json.dump({'version': 1, 'rules': rules}, f)
"
    echo "  ✓ $rule.yaml → $rule.json ($(python3 -c "import json; print(len(json.load(open('$BUILD_DIR/$rule.json'))['rules']))") rules)"
done

echo ""
echo "🔨 Compiling JSON → SRS..."

for rule in direct proxy reject private; do
    json_file="$BUILD_DIR/$rule.json"
    srs_file="$BUILD_DIR/$rule.srs"
    rules_count=$(python3 -c "import json; print(len(json.load(open('$json_file'))['rules']))")
    if [ "$rules_count" -eq 0 ]; then
        echo "  → $rule.srs (empty — skipping)"
        : > "$srs_file"
        continue
    fi
    echo "  → $rule.json → $rule.srs ($rules_count rules)"
    sing-box rule-set compile \
        --output "$srs_file" \
        "$json_file"
done

# Copy source YAML to dist/clash
cp "$RULES_DIR"/*.yaml "$DIST_DIR/clash/"

# Copy compiled SRS to dist/sing-box
cp "$BUILD_DIR"/*.srs "$DIST_DIR/sing-box/"

echo ""
echo "✅ Build complete"
echo "📦 Output:"
echo "   Clash YAML:   $DIST_DIR/clash/"
echo "   Sing-box SRS: $DIST_DIR/sing-box/"
