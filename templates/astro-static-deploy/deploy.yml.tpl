# ──────────────────────────────────────────────────────────────────────────────
# Deploy (Preview)
# ──────────────────────────────────────────────────────────────────────────────
# Corre en cada PR contra main y publica un preview en Cloudflare Pages,
# comentando la URL en el propio PR.
#
# El nombre del proyecto en Cloudflare Pages sale de la variable de repo
# CF_PROJECT_NAME (Settings → Secrets and variables → Actions → Variables):
# este preview se publica en "${CF_PROJECT_NAME}-dev".
# ──────────────────────────────────────────────────────────────────────────────

name: Deploy (Preview)

on:
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened]

concurrency:
  group: deploy-preview-${{ github.event.pull_request.number }}
  cancel-in-progress: true

jobs:
  deploy:
    if: ${{ !startsWith(github.head_ref, 'release-please--') }}
    uses: Lybo-Labs/cicd/.github/workflows/cloudflare-pages-deploy.yml@__CICD_SHA__
    with:
      project-name: ${{ vars.CF_PROJECT_NAME }}-dev
      environment: preview
      branch: ${{ github.head_ref }}
      node-version-file: .nvmrc
      build-command: npm run build
      output-directory: dist
    secrets:
      CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
      CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
