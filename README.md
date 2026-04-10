# homelab-mediawiki

Pre-built MediaWiki container image for homelab deployment.

Extends the official `mediawiki:fpm-alpine` image with:

- PostgreSQL and Redis PHP extensions (compiled, not built at runtime)
- Runtime dependencies: librsvg, lua5.1
- Additional MediaWiki extensions: CodeMirror, Interwiki, Variables,
  VariablesLua, LuaCache, Mermaid, PortableInfobox

## Why

The official MediaWiki image ships without PostgreSQL or Redis support.
Building PHP extensions from source on every pod startup adds ~10 minutes
to each deployment. This image does the compilation once at build time.

## Image

Published to `ghcr.io/danielsreichenbach/homelab-mediawiki` via GitHub
Actions on every push to `main`.

Tags:

- `1.45.1-fpm-alpine-<sha>` -- immutable, pinned to a specific commit
- `1.45.1-fpm-alpine` -- moving tag, latest build for this version
- `latest` -- latest build

## Updating

### MediaWiki version

1. Update `MEDIAWIKI_VERSION` in `.github/workflows/build.yml`
2. Update `ARG MEDIAWIKI_VERSION` default in `Dockerfile`
3. Check extension compatibility with the new `REL` branch
4. Push to `main`

### Extensions

Edit the extension download section in `Dockerfile`. Pin versions where
possible (tags over branches).
