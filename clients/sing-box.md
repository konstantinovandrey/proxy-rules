# Sing-box Setup

## Config File

1. Download or copy `dist/sing-box/config.json` to your device
2. Replace `YOUR_USERNAME`, `YOUR_SERVER`, and `YOUR_PASSWORD` with real values
3. Run:

```bash
sing-box run -c config.json
```

## Rule Set Auto-Update

The provided `config.json` uses **remote rule sets** with `update_interval: "24h"`.
Sing-box will download fresh `.srs` files automatically every 24 hours.

## Geo Databases

GeoIP and GeoSite databases are also fetched remotely from SagerNet's GitHub releases.
No manual download needed.

## Verify Rule Matching

```bash
# Test whether a domain matches a rule set
sing-box rule-set match -c config.json -r direct -d cardlink.link

# Test against proxy rule set
sing-box rule-set match -c config.json -r proxy -d youtube.com

# Dry-run check config validity
sing-box check -c config.json
```

## Local Rule Compilation

If you want to compile rules locally instead of fetching remote `.srs` files:

```bash
# Install sing-box, then
sing-box rule-set compile -o direct.srs rules/direct.yaml
sing-box rule-set compile -o proxy.srs rules/proxy.yaml
sing-box rule-set compile -o reject.srs rules/reject.yaml

# Reference them as local rule sets in config.json:
# "rule_set": [
#   { "tag": "direct", "type": "local", "format": "binary", "path": "direct.srs" },
#   ...
# ]
```

## Daemon (Linux)

```bash
# Systemd service
sudo cat > /etc/systemd/system/sing-box.service << 'EOF'
[Unit]
Description=Sing-box Proxy
After=network.target

[Service]
ExecStart=/usr/local/bin/sing-box run -c /etc/sing-box/config.json
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now sing-box
```
