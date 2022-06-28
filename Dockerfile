FROM alpine:3.16
LABEL maintainer="Hetao<hetao@hetao.name>"
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
	&& apk update \
	&& apk add tzdata  \
	&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
	&& echo "Asia/Shanghai" > /etc/timezone

#php extensions-81
RUN apk add php81-pear php81-dev php81-cli php81-fpm php81-imap php81-mbstring php81-json php81-common php81-ldap php81-pdo_mysql php81-mysqlnd php81-mysqli php81-bcmath php81-curl php81-opcache php81-gd php81-xml php81-simplexml php81-iconv php81-openssl php81-session php81-zip php81-ftp php81-pcntl php81-sockets php81-gettext php81-exif php81-tokenizer php81-sysvsem php81-calendar php81-dom php81-posix php81-fileinfo php81-phar php81-xmlreader php81-xmlwriter php81-sysvmsg php81-shmop php81-ctype

#php pecl extensions-81
RUN apk add php81-pecl-redis php81-pecl-imagick php81-pecl-swoole php81-pecl-xhprof

#https://pkgs.alpinelinux.org/packages?page=1&branch=edge&name=%2Agrpc%2A
RUN apk add php81-pecl-mcrypt php81-pecl-grpc --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN ln -s /usr/bin/php81 /usr/bin/php
RUN ln -s /usr/sbin/php-fpm81 /usr/sbin/php-fpm

#mkdir default config
RUN mkdir -p /data/www/www \
    && cp /etc/php81/php.ini /etc/php81/php.ini.bak \
    && cp /etc/php81/php-fpm.conf  /etc/php81/php-fpm.conf.bak \
    && cp /etc/php81/php-fpm.d/www.conf /etc/php81/php-fpm.d/www.conf.bak


WORKDIR /data/www/

COPY docker/start.sh /data/start.sh
COPY docker/fpm/php.ini /etc/php81/php.ini
COPY docker/fpm/php-fpm.conf /etc/php81/php-fpm.conf
COPY docker/fpm/pool.d/www.conf /etc/php81/php-fpm.d/www.conf

COPY index.php www/

#RUN apk add tree
#RUN tree -L 3 /etc/
#RUN tree -L 3 /usr/bin/

#RUN php -m
#RUN ls /usr/sbin

#代码检查
RUN find . -type f -name '*.php' -exec php -l {} \; | (! grep -v "No syntax errors detected" )

HEALTHCHECK --interval=5s --timeout=5s --retries=3 \
    CMD ps aux | grep "php-fpm:" | grep -v "grep" > /dev/null; if [ 0 != $? ]; then exit 1; fi
EXPOSE 9000
CMD ["/bin/sh","/data/start.sh"]
