#
# mantisbt Docker container
#
# Version 0.1

FROM php:7.4-apache
LABEL maintainer="Andrew Cooper <andrew.cooper@novatechweb.com>"

RUN sed -i 's| main$| main contrib non-free|' /etc/apt/sources.list \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        libcurl4 \
        libjpeg62-turbo \
        libmcrypt4 \
        libpq5 \
        libcurl4-openssl-dev \
        libfreetype6 \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libmcrypt-dev \
        libpng16-16 \
        libpq-dev \
        libxml2-dev \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install intl mysqli pgsql opcache ldap gd soap \
    && pecl install mcrypt-1.0.3 \
    && docker-php-ext-enable mcrypt \
    && DEBIAN_FRONTEND=noninteractive apt-get purge --yes \
        autoconf \
        build-essential \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libmcrypt-dev \
        libpq-dev \
        libxml2-dev \
    && rm -rf /var/www/html/index.html \
    && DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV MANTISBT_VERSION 2.24.2
ENV MANTISBT_SHA512 81d339aa60b8878b5398d7f7ef1f66151877742fac22944e67394ac087c1f4f2c8d5f270127dacc59cbead1a478a6698380b113abbc6a38177e87cc78cd0acd8
ENV MANTISBT_URL http://downloads.sourceforge.net/project/mantisbt/mantis-stable/${MANTISBT_VERSION}/mantisbt-${MANTISBT_VERSION}.tar.gz
ENV MANTISBT_FILE /tmp/mantisbt.tar.gz
ENV MANTISBT_BASE_DIR /var/www/html

# download and extract mantisbt
RUN mkdir -p /usr/src/mantisbt \
&&  mkdir -p /var/www/html \
&&  curl -fLS "${MANTISBT_URL}" -o "${MANTISBT_FILE}" \
&&  echo "${MANTISBT_SHA512}" "${MANTISBT_FILE}" | sha512sum -c \
&&  tar -xz --strip-components=1 -f "${MANTISBT_FILE}" -C "${MANTISBT_BASE_DIR}" \
&&  rm -rf "${MANTISBT_BASE_DIR}/doc/"

# copy over files
COPY ntlogosmall.png images/
COPY \
    config/000-default-ssl.conf \
    config/000-default.conf \
    config/000-mantisbt.conf \
        /etc/apache2/sites-available/
COPY config/php.ini /usr/local/etc/php/
COPY ./docker-entrypoint.sh \
    ./configure.sh \
        /

# run the configuration script
RUN ["/bin/bash", "/configure.sh"]

# specify which network ports will be used
EXPOSE 80 443

# start the entrypoint script
WORKDIR /var/www/html
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mantisbt"]
