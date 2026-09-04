# ──────────────────────────────────────────────────────────────────────────────
# Auto-release: crea tags + GitHub Releases al mergear a main
# ──────────────────────────────────────────────────────────────────────────────
# Usa release-please (Google) con Conventional Commits:
#   feat: ...  → minor bump (v1.1.0)
#   fix: ...   → patch bump (v1.0.1)
#   feat!: ... → major bump (v2.0.0)
#
# Flujo:
#   1. Un merge a main dispara este workflow.
#   2. release-please abre/actualiza un "Release PR" con changelog + bump.
#   3. Al mergear ese Release PR, crea el tag y el GitHub Release.
#   4. Desde ese tag se corre "Deploy (Manual)" con environment: production.
# ──────────────────────────────────────────────────────────────────────────────

name: Release

on:
  push:
    branches: [main]

jobs:
  release:
    permissions:
      contents: write
      pull-requests: write
    uses: Lybo-Labs/cicd/.github/workflows/release.yml@__CICD_SHA__
    with:
      release-type: node
