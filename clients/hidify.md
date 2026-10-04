# Hidify Setup

> **Privacy:** profile configs contain your server UUID (your proxy credential).
> Do NOT publish them on public repositories or exchange them on public URLs.
> The recommended flow is the server subscription link below — the server
> generates your full config on the fly and it is protected by a personal
> token (hand it over via a private channel, e.g. messenger).

## Method 1: Server Subscription Link (Best)

The proxy server generates a full Sing-box config for every user on the fly,
with all routing rules (ads/tracking → block, private/RU → direct, the rest →
proxy) and a personal UUID. The config's `rule_set` entries fetch the rules
from GitHub Pages and refresh every 24h (`update_interval: "24h"`) — nothing
more to do, no re-imports.

1. Get your personal link from the operator — it looks like this:
   ```
   https://plangenservicedomain.online/c/<your-name>/<your-token>
   ```
   for example `https://plangenservicedomain.online/c/andrey-mobile/WMFJNX`.
   The token is your personal secret — do not share it.
2. Open **Hidify** → **Settings** → **Import Config** → **From URL**
3. Paste your link and confirm. Hidify fetches the config (with rules) and
   keeps it updated on refresh.

> Plain (rule-less) links stay available as `https://plangenservicedomain.online/s/<name>/<token>`
> for clients that need a bare vless/trojan link. `/c/...` is the full-config
> endpoint and is what you want on phones.

## Method 2: Personal Config File Import (Backup)

If the server is unreachable, a previously exported config file works offline:

1. Receive your personal config file (`config-andrey-mobile.json` /
   `config-dasha-mobile.json`) via a private channel — do not fetch it from a
   public URL; it contains your UUID.
2. Open **Hidify** → **Settings** → **Import Config** → **From File** (or
   copy the file text and use **From Clipboard**).
3. The config's `rule_set` entries fetch the rules from GitHub Pages and
   refresh every 24h — nothing more to do.

## Method 3: Clash Config Import

Hidify also supports Clash.Meta configs.

1. **Settings** → **Import Config** → **From URL**
2. Paste the Clash config URL:
   ```
   https://konstantinovandrey.github.io/proxy-rules/clash/config.yaml
   ```

## Method 4: Manual Rule Addition

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

---

## Apps that refuse to work through VPN

Russian apps (Magnit, Gosuslugi, banks) reject foreign IPs and then tell you
to turn the VPN off. Routing rules cannot fix this: an app sees the VPN
interface no matter where its traffic is routed, so the app itself has to be
taken out of the VPN.

One-tap fix (server exit is in Amsterdam), in Russian:
**[Apps and VPN (Hiddify)](./hiddify-apps.md)**