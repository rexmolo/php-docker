#php 56 base
FROM shopex/centos6.8
MAINTAINER zhangxuehui <zhangxuehui@shopex.cn>
ENV PHP_VERSION 56
ENV PHP_PATH /usr/local/php${PHP_VERSION}
ENV PHP_EXT_PATH ${PHP_PATH}/etc/php.d
#install php-fpm
RUN yum install php-fpm${PHP_VERSION} -y
RUN yum install Zend${PHP_VERSION}  -y
RUN yum install php-memcache${PHP_VERSION} -y
RUN yum install php-mongo${PHP_VERSION} -y
RUN yum install php-redis${PHP_VERSION} -y
RUN yum install php-swoole${PHP_VERSION} -y
RUN yum install php-amqp${PHP_VERSION} -y

RUN echo "zend_loader.license_path='/data/httpd/docker/php/php-fpm56/etc/'" >>  /usr/local/php56/etc/php.d/Zend.ini
RUN sed -i 's/127.0.0.1:9000/[::]:9000/g' "/usr/local/php56/etc/php-fpm.conf"
RUN sed -i 's/;daemonize = yes/daemonize = no/g' "/usr/local/php56/etc/php-fpm.conf"
RUN sed -i 's/ = 128/ = 5/g' "/usr/local/php56/etc/php-fpm.conf"
RUN sed -i 's/display_errors = Off/display_errors = On/g' "$PHP_PATH/etc/php.ini"

RUN ln -s /usr/local/php${PHP_VERSION}/sbin/php-fpm /usr/sbin/php-fpm
RUN ln -s /usr/local/php${PHP_VERSION}/bin/php /usr/sbin/php
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
#RUN php composer-setup.php 
#RUN php -r "unlink('composer-setup.php');"
#RUN mv composer.phar /usr/sbin/composer
#RUN chmod +x /usr/sbin/composer

COPY php-fpm.sh /usr/sbin/php-fpm56
RUN chmod +x /usr/sbin/php-fpm56
ENTRYPOINT ["php-fpm56"]