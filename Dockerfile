FROM php:8.3-apache

RUN apt-get update && apt-get install -y  \
    libfreetype6-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    libjpeg-dev \
    libzip-dev \
    libpng-dev \
    libwebp-dev \
    nodejs \
    npm \
    --no-install-recommends \
    && docker-php-ext-enable opcache \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql -j$(nproc) gd \
    && docker-php-ext-install calendar exif intl pcntl\
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y zlib1g-dev libzip-dev && \
    docker-php-ext-install zip

# Update apache conf to point to application public directory
ENV APACHE_DOCUMENT_ROOT=/var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Update uploads config
RUN echo "file_uploads = On\n" \
         "memory_limit = 1024M\n" \
         "upload_max_filesize = 512M\n" \
         "post_max_size = 512M\n" \
         "max_execution_time = 1200\n" \
         > /usr/local/etc/php/conf.d/uploads.ini

# Enable headers module
RUN a2enmod rewrite headers