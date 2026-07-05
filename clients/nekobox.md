# Nekobox Setup

## Method 1: Subscription (Clash Config — Recommended)

1. Open **Nekobox** → **Profiles** tab → tap **+** → **Import from URL**
2. Paste your Clash config URL:
   ```
   https://YOUR_USERNAME.github.io/proxy-rules/clash/config.yaml
   ```
3. Enable **Auto Update** (set interval to 24h)
4. Tap **Save** — Nekobox will download rules, proxies, and start routing

## Method 2: Manual Rule Addition

If you only need a few exclusions and don't want the full rule set:

1. **Rules** tab → **Add Rule Set**
2. Configure each exclusion:

   | Type | Value | Outbound |
   |------|-------|----------|
   | `DOMAIN-SUFFIX` | `cardlink.link` | `DIRECT` |
   | `DOMAIN-SUFFIX` | `your-company.com` | `DIRECT` |
   | `IP-CIDR` | `10.0.0.0/8` | `DIRECT` |

## Method 3: Rule Provider (Advanced)

1. **Settings** → **Rule Providers** → tap **+**
2. For each rule set, enter:

   | Name | Type | URL | Interval |
   |------|------|-----|----------|
   | `direct` | `HTTP` | `https://YOUR_USERNAME.github.io/proxy-rules/clash/direct.yaml` | `86400` |
   | `proxy` | `HTTP` | `https://YOUR_USERNAME.github.io/proxy-rules/clash/proxy.yaml` | `86400` |
   | `reject` | `HTTP` | `https://YOUR_USERNAME.github.io/proxy-rules/clash/reject.yaml` | `86400` |

3. Go to **Rules** → **Add Rule** for each:

   ```
   RULE-SET,direct,DIRECT
   RULE-SET,proxy,PROXY
   RULE-SET,reject,REJECT
   ```

## Verify

Open a browser and visit `http://cardlink.link` — it should connect DIRECT (no proxy icon).
