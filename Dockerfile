FROM webplates/symfony-php:7.0-fpm-alpine

RUN set -xe \
    && apk add --no-cache libxml2-dev \
    && docker-php-ext-install -j$(nproc) soap

# Production PHP configuration
COPY etc/docker/prod/app/php.ini /usr/local/etc/php/php.ini

COPY composer.json composer.lock ./
RUN composer install --prefer-dist --no-dev --no-autoloader --no-scripts --no-interaction --quiet

COPY . .

# Build and cleanup
RUN set -xe \
    && composer dump-autoload --optimize \
    && composer run-script post-install-cmd \
    && bin/console assetic:dump \
    && bin/console assets:install \
    && mv web/ public/ \
    && bin/console cache:clear --no-warmup \
    && rm -rf etc/ \
        var/cache/* \
        var/logs/* \
    && mkdir -p var/sessions/ var/uploads/ \
    && chmod -R 777 var/sessions/ var/uploads/

VOLUME ["/app/web", "/app/var/sessions", "/app/var/uploads"]

COPY etc/docker/prod/app/entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
