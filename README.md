# CICD

Workflows reusables de GitHub Actions compartidos por los repos de Lybo Labs
(`.github/workflows/`). Cada repo consumidor los invoca con `uses:
Lybo-Labs/cicd/.github/workflows/<workflow>.yml@<sha>`, fijado a un commit
específico (no `@main`).

## Documentación

Guías paso a paso de cómo usar estos workflows viven en [`docs/`](docs/):

- [Deploy de una landing Astro a Cloudflare Pages](docs/cloudflare-pages-deploy.md) —
  recursos necesarios, acceso a Cloudflare, creación del proyecto, Account ID,
  API Token y configuración del repo en GitHub.
