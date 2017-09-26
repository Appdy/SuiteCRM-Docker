FROM php:7-apache

ENV SRC_FOLDER src
ENV WWW_FOLDER /var/www/html
ENV WWW_USER www-data
ENV WWW_GROUP www-data

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y libcurl4-gnutls-dev libpng-dev libssl-dev libc-client2007e-dev libkrb5-dev unzip cron re2c python tree vim-tiny && \
    docker-php-ext-configure imap --with-imap-ssl --with-kerberos && \
    docker-php-ext-install mysqli curl gd zip mbstring imap && \
    rm -rf /var/lib/apt/lists/*

RUN chown -R ${WWW_USER}:${WWW_GROUP} ${WWW_FOLDER}

ADD config/php.ini /usr/local/etc/php/php.ini
ADD config/config_override.php.pyt /usr/local/src/config_override.php.pyt
ADD config/envtemplate.py /usr/local/bin/envtemplate.py
ADD config/init.sh /usr/local/bin/init.sh

RUN chmod u+x /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/envtemplate.py

ADD config/crons.conf /etc/cron.d/crons.conf
RUN crontab /etc/cron.d/crons.conf

EXPOSE 80

ENTRYPOINT ["init.sh"]
CMD ["apache2-foreground"]
