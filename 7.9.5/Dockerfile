FROM php:5.6-apache

ENV DOWNLOAD_URL http://downloads.sourceforge.net/project/suitecrm/SuiteCRM-7.9.5.zip?r=&ts=1458855387&use_mirror=iweb
# ENV DOWNLOAD_FILE suitecrm-7.9.5.zip
ENV DOWNLOAD_FILE SuiteCRM-7.9.5.zip
ENV EXTRACT_FOLDER SuiteCRM-7.9.5
ENV WWW_FOLDER /var/www/html
ENV WWW_USER www-data
ENV WWW_GROUP www-data
ENV SRC_FOLDER /usr/src

RUN mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh && \
    chown -R root:root /root/.ssh

COPY config/authorized_keys /root/.ssh/authorized_keys
RUN chmod 644 /root/.ssh/authorized_keys

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y libcurl4-gnutls-dev libpng-dev libssl-dev libc-client2007e-dev libkrb5-dev unzip cron re2c python tree && \
    apt-get install -y vim-tiny && \
    docker-php-ext-configure imap --with-imap-ssl --with-kerberos && \
    docker-php-ext-install mysqli curl gd zip mbstring imap && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p $SRC_FOLDER

WORKDIR $SRC_FOLDER

ADD $EXTRACT_FOLDER ${SRC_FOLDER}/

# curl -o $DOWNLOAD_FILE -L "${DOWNLOAD_URL}" && \
# RUN
# unzip -d . $DOWNLOAD_FILE && \
  # rm $DOWNLOAD_FILE && \
  # rm -rf ${WWW_FOLDER}/* && \
RUN cp -R * ${WWW_FOLDER}/ && \
  chown -R ${WWW_USER}:${WWW_GROUP} ${WWW_FOLDER}/* && \
  chown -R ${WWW_USER}:${WWW_GROUP} ${WWW_FOLDER}

ADD php.ini /usr/local/etc/php/php.ini
ADD config_override.php.pyt /usr/local/src/config_override.php.pyt
ADD envtemplate.py /usr/local/bin/envtemplate.py
ADD init.sh /usr/local/bin/init.sh

RUN chmod u+x /usr/local/bin/init.sh
RUN chmod u+x /usr/local/bin/envtemplate.py

ADD crons.conf /etc/cron.d/crons.conf
RUN crontab /etc/cron.d/crons.conf

EXPOSE 80

ENTRYPOINT ["init.sh"]
CMD ["apache2-foreground"]
