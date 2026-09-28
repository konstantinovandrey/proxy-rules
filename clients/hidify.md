# Hidify Setup

> **Privacy:** profile configs contain your server UUID (your proxy credential).
> Do NOT publish them on public repositories. Download your personal config
> file once (via chat / secure transfer) and import it into Hidify — the
> rule sets themselves auto-update every 24h from GitHub Pages via `rule_set`
> URLs inside the config, so you never need to re-import.

## Method 1: Sing-box Config Import (Best)

Hidify has native Sing-box support with auto-updating rule sets.

1. Receive your personal config file (`config-andrey-mobile.json` /
   `config-dasha-mobile.json`) via a private channel — do not fetch it from a
   public URL; it contains your UUID.
2. Open **Hidify** → **Settings** → **Import Config** → **From File** (or
   copy the file text and use **From Clipboard**).
3. The config's `rule_set` entries fetch the rules from GitHub Pages and
   refresh every 24h (`update_interval: "24h"`) — nothing more to do.

## Method 2: Clash Config Import

Hidify also supports Clash.Meta configs.

1. **Settings** → **Import Config** → **From URL**
2. Paste the Clash config URL:
   ```
   https://konstantinovandrey.github.io/proxy-rules/clash/config.yaml
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
