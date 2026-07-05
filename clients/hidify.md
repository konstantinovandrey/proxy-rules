# Hidify Setup

## Method 1: Sing-box Config Import (Best)

Hidify has native Sing-box support with auto-updating rule sets.

1. Open **Hidify** → **Settings** → **Import Config** → **From URL**
2. Paste the Sing-box config URL:
   ```
   https://YOUR_USERNAME.github.io/proxy-rules/sing-box/config.json
   ```
3. Enable **Auto Update** (available in the config itself — `update_interval: "24h"`)

## Method 2: Clash Config Import

Hidify also supports Clash.Meta configs.

1. **Settings** → **Import Config** → **From URL**
2. Paste the Clash config URL:
   ```
   https://YOUR_USERNAME.github.io/proxy-rules/clash/config.yaml
   ```

## Method 3: Manual Rule Addition

1. **Rules** → **Custom Rules** → tap **Add**
2. Create entries:

   | Type | Value | Action |
   |------|-------|--------|
   | `DOMAIN-SUFFIX` | `cardlink.link` | `DIRECT` |
   | `DOMAIN-SUFFIX` | `your-company.com` | `DIRECT` |
   | `IP-CIDR` | `10.0.0.0/8` | `DIRECT` |

## Custom DNS (Optional)

If you need DNS routing, add these in **Settings** → **DNS**:

| Domain | DNS Server |
|--------|------------|
| `cardlink.link` | `1.1.1.1` |
| `*.internal` | `192.168.1.1` |
