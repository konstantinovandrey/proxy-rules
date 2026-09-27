#!/usr/bin/env bash
set -euo pipefail

# Build all rule sets from geosite/geoip categories + custom YAML
# Requires: sing-box (https://github.com/SagerNet/sing-box)
#   Install: curl -Lo /tmp/sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/latest/download/sing-box-linux-amd64.tar.gz
#            tar -xzf /tmp/sing-box.tar.gz && sudo mv sing-box /usr/local/bin/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
RULES_DIR="$ROOT_DIR/rules"
BUILD_DIR="$ROOT_DIR/build"
DIST_DIR="$ROOT_DIR/dist"
GEO_DIR="$BUILD_DIR/geo"

mkdir -p "$BUILD_DIR" "$DIST_DIR/clash" "$DIST_DIR/sing-box" "$GEO_DIR"

echo "🌐 Downloading geo databases (cached in build/geo)..."

if [ ! -f "$GEO_DIR/geosite.db" ]; then
    curl -fL -o "$GEO_DIR/geosite.db" \
        "https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db"
fi
if [ ! -f "$GEO_DIR/geoip.db" ]; then
    curl -fL -o "$GEO_DIR/geoip.db" \
        "https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db"
fi

echo ""
echo "🔨 Building sing-box rule sets (.srs)..."

# 1. Geosite categories → source JSON → binary SRS
build_geosite () {
    cat="$1"
    # Export category to source JSON
    sing-box geosite export -f "$GEO_DIR/geosite.db" -o "$BUILD_DIR/$cat.json" "$cat"
    # Compile to binary (small + fast)
    sing-box rule-set compile -o "$DIST_DIR/sing-box/$cat.srs" "$BUILD_DIR/$cat.json"
    echo "  ✓ geosite/$cat → $cat.srs"
}

# 2. Custom domain rules from rules/*.yaml → source JSON → binary SRS
#    GEOSITE/GEOIP entries are inlined by exporting the category from the
#    sing-box geo databases (rule-set schema has no geosite/geoip reference).
build_yaml () {
    rule="$1"
    out="$2"
    PYTHON_BIN="${PYTHON_BIN:-python3}"
    GEO_DIR="$GEO_DIR" "$PYTHON_BIN" - "$RULES_DIR/$rule.yaml" "$BUILD_DIR/$out.json" "$rule" <<'PYEOF'
import json
import os
import subprocess
import sys

import yaml

GEO_DIR = os.environ.get("GEO_DIR", "build/geo")


def export_rules(db_kind, category, tmp_path):
    """Export a geosite/geoip category; returns (rules, error_string)."""
    db = os.path.join(GEO_DIR, f"{db_kind}.db")
    proc = subprocess.run(
        ["sing-box", db_kind, "export", "-f", db, "-o", tmp_path, category],
        capture_output=True, text=True,
    )
    if proc.returncode != 0:
        return None, proc.stderr.strip()
    with open(tmp_path) as f:
        return json.load(f).get("rules", []), None


rule_name = sys.argv[3]
with open(sys.argv[1]) as f:
    data = yaml.safe_load(f)
rules = []
for entry in data.get("payload", []):
    parts = entry.split(",", 1)
    if len(parts) != 2:
        continue
    t, v = (p.strip() for p in parts)
    r = {}
    if t == "DOMAIN-SUFFIX":      r["domain_suffix"] = [v]
    elif t == "DOMAIN":           r["domain"] = [v]
    elif t == "DOMAIN-KEYWORD":   r["domain_keyword"] = [v]
    elif t == "IP-CIDR":          r["ip_cidr"] = [v]
    elif t == "IP-CIDR6":         r["ip_cidr6"] = [v]
    elif t == "GEOSITE":
        tmp = f"{sys.argv[2]}.geosite.tmp.json"
        got, err = export_rules("geosite", v.lower(), tmp)
        if got is None:
            sys.exit(f"ERROR: {rule_name}.yaml: GEOSITE category '{v}' not found in geosite.db\n  {err}")
        rules.extend(got)
        continue
    elif t == "GEOIP":
        tmp = f"{sys.argv[2]}.geoip.tmp.json"
        got, err = export_rules("geoip", v.lower(), tmp)
        if got is None:
            sys.exit(f"ERROR: {rule_name}.yaml: GEOIP category '{v}' not found in geoip.db\n  {err}")
        rules.extend(got)
        continue
    elif t == "MATCH":
        print(f"  ⚠ {rule_name}.yaml: MATCH skipped — rule-set schema has no MATCH; "
              f"catch-all lives in route.final / Clash MATCH rule")
        continue
    else:                         continue
    rules.append(r)
with open(sys.argv[2], "w") as f:
    json.dump({"version": 2, "rules": rules}, f)
PYEOF
    sing-box rule-set compile -o "$DIST_DIR/sing-box/$out.srs" "$BUILD_DIR/$out.json"
    size=$(wc -c < "$DIST_DIR/sing-box/$out.srs")
    echo "  ✓ rules/$rule.yaml → $out.srs ($size bytes)"
}

# Geosite categories referenced by config.json
for cat in category-ru category-ads-all private google youtube telegram github openai anthropic twitter facebook instagram netflix discord reddit; do
    build_geosite "$cat"
done

# Custom rule files (domains/IP from YAML) → prefixed custom-*
for rule in direct proxy reject private; do
    if [ -s "$RULES_DIR/$rule.yaml" ]; then
        build_yaml "$rule" "custom-$rule"
    fi
done

# Copy source YAML to dist/clash (rule-providers consume these directly)
cp "$RULES_DIR"/*.yaml "$DIST_DIR/clash/"

echo ""
echo "✅ Build complete"
echo "📦 Output:"
echo "   Sing-box SRS: $DIST_DIR/sing-box/"
echo "   Clash YAML:   $DIST_DIR/clash/"