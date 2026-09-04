# ──────────────────────────────────────────────────────────────────────────────
# Manual deploy
# ──────────────────────────────────────────────────────────────────────────────
# Usage:
#   1. Ir a Actions → "Deploy (Manual)"
#   2. Elegir la rama o tag desde "Use workflow from"
#   3. Elegir el ambiente destino
#   4. Run workflow
#
# El nombre del proyecto en Cloudflare Pages sale de la variable de repo
# CF_PROJECT_NAME (Settings → Secrets and variables → Actions → Variables):
#   - development → ${CF_PROJECT_NAME}-dev
#   - staging     → ${CF_PROJECT_NAME}-staging
#   - production  → ${CF_PROJECT_NAME}
#
# Producción exige que el trigger sea un tag y requiere aprobación del
# Environment "production" (configurar Required reviewers en Settings).
# ──────────────────────────────────────────────────────────────────────────────

name: Deploy (Manual)
run-name: "Deploy → ${{ inputs.environment }}"

on:
  workflow_dispatch:
    inputs:
      environment:
        description: "Target environment"
        required: true
        type: choice
        options:
          - development
          - staging
          - production

concurrency:
  group: deploy-manual-${{ inputs.environment }}
  cancel-in-progress: false

jobs:
  # ─── Guard: production only from tags ─────────────────────────────────
  validate:
    if: inputs.environment == 'production'
    runs-on: ubuntu-latest
    steps:
      - name: Require tag for production
        run: |
          REF="${{ github.ref }}"
          if [[ "$REF" != refs/tags/* ]]; then
            echo "::error::Production deploys must be triggered from a tag (e.g. v1.0.0). Got: $REF"
            exit 1
          fi

  deploy:
    needs: validate
    if: always() && (needs.validate.result == 'success' || needs.validate.result == 'skipped')
    uses: Lybo-Labs/cicd/.github/workflows/cloudflare-pages-deploy.yml@__CICD_SHA__
    with:
      project-name: ${{ inputs.environment == 'production' && vars.CF_PROJECT_NAME || inputs.environment == 'staging' && format('{0}-staging', vars.CF_PROJECT_NAME) || format('{0}-dev', vars.CF_PROJECT_NAME) }}
      environment: ${{ inputs.environment }}
      branch: main
      node-version-file: .nvmrc
      build-command: npm run build
      output-directory: dist
    secrets:
      CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
      CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
