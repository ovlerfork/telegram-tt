# Static hosting

Telegram Web A builds to a static `dist/` directory, so the patched web app can be hosted on GitHub Pages or Cloudflare Pages.

## GitHub Pages

Workflow: `.github/workflows/pages.yml`.

Required repository secrets:

- `TELEGRAM_API_ID`
- `TELEGRAM_API_HASH`

Optional repository variable:

- `BASE_URL` — defaults to `https://<owner>.github.io/<repo>/`.

Enable Pages in repository settings with **GitHub Actions** as the source, then run **Deploy Web to GitHub Pages** manually or let it run after a successful Patch Check.

The workflow:

1. checks out `patchset`,
2. checks out upstream `Ajaxy/telegram-tt`,
3. applies `patches/cur`,
4. runs `npm install` and `npm run build:production`,
5. deploys `dist/` via GitHub Pages.

## Cloudflare Pages

Cloudflare Pages can host the same static output.

Recommended setup:

- Connect repository: `ovlerfork/telegram-tt`
- Production branch: `patched` if you want Cloudflare to build from source directly, or `patchset` if using a custom workflow to apply patches first.
- Build command if building from already-generated `patched`: `npm install && npm run build:production`
- Build output directory: `dist`
- Environment variables:
  - `TELEGRAM_API_ID`
  - `TELEGRAM_API_HASH`
  - `BASE_URL` set to the final Cloudflare Pages URL or custom domain

For the strict patchset model, prefer a GitHub Action that applies patches and deploys to Cloudflare via Wrangler, because Cloudflare's default Git integration does not know how to combine `patchset` plus upstream automatically.
