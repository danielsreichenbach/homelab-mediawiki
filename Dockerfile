ARG MEDIAWIKI_VERSION=1.45.1-fpm-alpine

FROM mediawiki:${MEDIAWIKI_VERSION}

# Install runtime dependencies and build PHP extensions in one layer
RUN set -eux; \
    apk add --no-cache \
        libpq \
        librsvg \
        rsvg-convert \
        lua5.1 \
    ; \
    apk add --no-cache --virtual .build-deps \
        postgresql-dev \
        $PHPIZE_DEPS \
    ; \
    printf '\n\n\n\n\n' | pecl install redis; \
    docker-php-ext-enable redis; \
    docker-php-ext-install -j"$(nproc)" pgsql pdo_pgsql; \
    apk del --no-cache .build-deps; \
    rm -rf /tmp/pear

# Upload limits
RUN printf '[PHP]\nupload_max_filesize = 10M\npost_max_size = 12M\n' \
    > /usr/local/etc/php/conf.d/uploads.ini

# Install additional MediaWiki extensions not bundled in the image
RUN set -eux; \
    cd /var/www/html/extensions; \
    # CodeMirror
    wget -qO- https://github.com/wikimedia/mediawiki-extensions-CodeMirror/archive/refs/heads/REL1_45.tar.gz \
        | tar xz; \
    mv mediawiki-extensions-CodeMirror-REL1_45 CodeMirror; \
    # Interwiki
    wget -qO- https://github.com/wikimedia/mediawiki-extensions-Interwiki/archive/refs/heads/REL1_45.tar.gz \
        | tar xz; \
    mv mediawiki-extensions-Interwiki-REL1_45 Interwiki; \
    # Variables
    wget -qO- https://github.com/wikimedia/mediawiki-extensions-Variables/archive/refs/heads/REL1_45.tar.gz \
        | tar xz; \
    mv mediawiki-extensions-Variables-REL1_45 Variables; \
    # VariablesLua
    wget -qO- https://github.com/Liquipedia/VariablesLua/archive/refs/tags/1.6.0.tar.gz \
        | tar xz; \
    mv VariablesLua-1.6.0 VariablesLua; \
    # LuaCache
    wget -qO- https://gitlab.com/hydrawiki/extensions/LuaCache/-/archive/master/LuaCache-master.tar.gz \
        | tar xz; \
    mv LuaCache-master LuaCache; \
    # Mermaid
    wget -qO- https://github.com/SemanticMediaWiki/Mermaid/archive/refs/tags/6.0.2.tar.gz \
        | tar xz; \
    mv Mermaid-6.0.2 Mermaid; \
    # PortableInfobox
    wget -qO- https://github.com/Universal-Omega/PortableInfobox/archive/refs/heads/main.tar.gz \
        | tar xz; \
    mv PortableInfobox-main PortableInfobox
