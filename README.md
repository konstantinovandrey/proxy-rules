# Portable Proxy Rules

**One rule source → every client.** Sing-box, Nekobox, Hidify, Clash.Meta, Mihomo, v2ray, Xray.

Edit `rules/*.yaml` once. GitHub Actions compiles, deploys, and serves via GitHub Pages.

---

## Quick Start

### 1. Fork this repo

Click **Fork** → your GitHub account → `proxy-rules`.

### 2. Enable GitHub Pages

**Settings** → **Pages** → **Source**: **GitHub Actions**.

### 3. Update placeholder URLs

Search for `YOUR_USERNAME` across these files and replace with your actual GitHub username:

| File | Replace |
|------|---------|
| `dist/clash/config.yaml` | `YOUR_USERNAME` |
| `dist/sing-box/config.json` | `YOUR_USERNAME` |
| `dist/v2ray/routing.json` | (no change needed) |
| `clients/*.md` | `YOUR_USERNAME` in URLs |

### 4. Add your exclusions

Edit `rules/direct.yaml`:

```yaml
payload:
  - DOMAIN-SUFFIX,cardlink.link
  - DOMAIN-SUFFIX,your-internal-app.com
  - IP-CIDR,10.20.0.0/16
```

### 5. Push — and done

```bash
git add .
git commit -m "Customize exclusions"
git push
```

GitHub Actions builds everything and deploys to Pages automatically.

---

## Client URLs

After deployment, point your clients here:

| Client | Config URL |
|--------|------------|
| **Nekobox / Hidify / Clash.Meta / Mihomo** | `https://YOUR_USERNAME.github.io/proxy-rules/clash/config.yaml` |
| **Sing-box** | `https://YOUR_USERNAME.github.io/proxy-rules/sing-box/config.json` |
| **v2ray / Xray** | Copy `dist/v2ray/config.json` + `geoip.dat` + `geosite.dat` |

See per-client guides in [`clients/`](./clients/).

---

## Rule Syntax Reference

| Rule Type | Example | Matches |
|-----------|---------|---------|
| `DOMAIN-SUFFIX` | `example.com` | `example.com`, `api.example.com` |
| `DOMAIN` | `example.com` | `example.com` only (exact) |
| `DOMAIN-KEYWORD` | `google` | `google.com`, `googleapis.com`, `googleusercontent.com` |
| `IP-CIDR` | `192.168.0.0/16` | IPv4 range |
| `IP-CIDR6` | `fc00::/7` | IPv6 range |
| `GEOSITE` | `GOOGLE` | All domains in geosite category |
| `GEOIP` | `CN` | All China-assigned IP ranges |
| `MATCH` | — | Catch-all (must be last rule) |

---

## Repository Structure

```
proxy-rules/
├── rules/          ← Source of truth (Clash YAML)
│   ├── direct.yaml
│   ├── proxy.yaml
│   ├── reject.yaml
│   └── private.yaml
├── build/          ← Compiled .srs artifacts (gitignored)
├── dist/           ← Deployment output
│   ├── clash/      ← Clash YAML configs
│   ├── sing-box/   ← Sing-box SRS + geo databases
│   └── v2ray/      ← v2ray routing + geo databases
├── scripts/        ← Build / download / deploy
├── clients/        ← Per-client setup guides
└── .github/        ← CI/CD workflows
```

---

## Development

### Build locally

```bash
# Requires sing-box CLI
./scripts/build.sh
```

### Update geo databases

```bash
./scripts/download-geo.sh
```

### Validate configs

```bash
# Sing-box
sing-box check -c dist/sing-box/config.json

# Test rule matching
sing-box rule-set match -c dist/sing-box/config.json -r direct -d cardlink.link
```

---

## License

MIT — do whatever you want.
