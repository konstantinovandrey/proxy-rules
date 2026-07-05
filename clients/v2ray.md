# v2ray / Xray Setup

## Required Files

Place all three files in your config directory (e.g., `/etc/xray/` or `/usr/local/etc/v2ray/`):

| File | Source |
|------|--------|
| `geoip.dat` | v2fly/geoip release (auto-downloaded by `download-geo.sh`) |
| `geosite.dat` | v2fly/domain-list-community release |
| `config.json` | Merge `dist/v2ray/config.json` with your node settings |

## Config Structure

Your final `config.json` should merge:

```
config.json  (base: inbounds + outbounds + dns)
routing.json (routing rules — inline or referenced)
```

Example merged structure:

```json
{
  "log": { "loglevel": "warning" },
  "dns": { ... },
  "inbounds": [ ... ],
  "outbounds": [ ... ],
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [ ... ]
  }
}
```

## Domain Rule Syntax

v2ray uses several domain matching formats:

| Format | Example | Matches |
|--------|---------|---------|
| Plain | `"cardlink.link"` | Exact domain |
| `domain:` | `"domain:cardlink.link"` | Domain and subdomains |
| `keyword:` | `"keyword:cardlink"` | Any domain containing the word |
| `regexp:` | `"regexp:.*\\.cardlink\\.link$"` | Regex match |
| `geosite:` | `"geosite:google"` | Geosite category |

## GeoIP / GeoSite Usage

```json
{
  "domain": ["geosite:private", "geosite:google"],
  "ip": ["geoip:private", "geoip:cn"]
}
```

## Test Routing (Xray only)

```bash
# Query routing decision for a domain
xray api routing --server=127.0.0.1:10085 --domain=cardlink.link
# Expected: outboundTag = "direct"

xray api routing --server=127.0.0.1:10085 --domain=youtube.com
# Expected: outboundTag = "proxy"
```

## Update Geo Databases

```bash
# Manual update
./scripts/download-geo.sh

# Or download directly
curl -LO https://github.com/v2fly/geoip/releases/latest/download/geoip.dat
curl -LO https://github.com/v2fly/domain-list-community/releases/latest/download/dlc.dat
mv dlc.dat geosite.dat
```
