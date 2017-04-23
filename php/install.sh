#!/bin/bash

set -x
set -e

cd `dirname $0`
cwd=`pwd`
INSTALL_ROOT=/usr/local/services/
mkdir -p $INSTALL_ROOT

openssl=openssl-1.1.0e
openssl_root=$INSTALL_ROOT/openssl

pcre=pcre-8.39
pcre_root=$INSTALL_ROOT/pcre

nginx=nginx-1.11.10

libmemcached=libmemcached-1.0.18
libmemcached_root=$INSTALL_ROOT/libmemcached

php=php-5.6.30
php_root=$INSTALL_ROOT/$php

php7=php-7.1.2
php7_root=$INSTALL_ROOT/$php7

ext_root=$cwd/php-extensions

function install_openssl()
{
    cd $cwd
    mkdir -p $openssl_root
    tar zxf ${openssl}.tar.gz
    cd $cwd/$openssl
    ./config --prefix=$openssl_root
    make -j 4
    make install
}

function install_nginx()
{
    cd $cwd
    nginx_root=$INSTALL_ROOT/$nginx
    mkdir -p $nginx_root
    tar jxf ${pcre}.tar.bz2
    tar zxf ${nginx}.tar.gz
    cd $cwd/$nginx

    './configure' --prefix=$nginx_root --with-pcre=$cwd/${pcre} --user=nginx --group=nginx --with-http_ssl_module --with-openssl=$cwd/$openssl --without-http_autoindex_module --without-http_ssi_module --with-stream=dynamic

    make -j 4
    make install

    ln -s $nginx_root $INSTALL_ROOT/nginx

    chown -R nginx:nginx $nginx_root/conf
}

function install_libmemcached()
{
    cd $cwd
    mkdir -p $libmemcached_root
    tar zxf ${libmemcached}.tar.gz
    cd $cwd/$libmemcached
    ./configure --prefix=$libmemcached_root
    make -j 4
    make install
}

function install_php()
{
    cd $cwd
    if [ ! -e "${php}.tar.gz" ]; then
        wget -O ${php}.tar.gz "http://cn2.php.net/distributions/${php}.tar.gz"
    fi
    if [ ! -d $php_root ]; then
        mkdir -p $php_root
        tar zxf ${php}.tar.gz
        cd $cwd/$php
        './configure'  --prefix=$php_root '--with-pdo-mysql=mysqlnd' '--with-mcrypt' '--with-gd' '--with-freetype-dir' '--with-jpeg-dir' '--with-png-dir' '--with-zlib-dir' '--with-libxml-dir' '--with-readline' '--enable-xml' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-inline-optimization' '--with-curl' '--enable-mbregex' '--enable-mbstring' '--enable-gd-native-ttf' '--enable-pcntl' '--enable-sockets' '--enable-soap' '--without-pear' '--enable-session' '--enable-fpm' '--with-fpm-user=nginx' '--with-fpm-group=nginx' '--enable-zip' '--with-openssl'
    else
        cd $cwd/$php
    fi
    make -j 2
    make install
    cp php.ini-production $php_root/etc/php.ini
    cd $php_root/lib
    ln -s ../etc/php.ini
    cd $php_root/etc
    cp php-fpm.conf.default php-fpm.conf
    chown -R nginx:nginx $php_root/etc/ $php_root/lib/php.ini

    ln -s $php_root $INSTALL_ROOT/php
}

function install_php_memcached
{
    memcached=memcached-2.2.0
    cd $ext_root
    tar zxf ${memcached}.tgz
    cd $memcached
    $php_root/bin/phpize
    ./configure --with-php-config=$php_root/bin/php-config --disable-memcached-sasl
    make -j 4
    make install
}

function install_php_redis()
{
    redis=phpredis-3.1.1
    cd $ext_root
    tar zxf ${redis}.tar.gz
    cd $redis
    $php_root/bin/phpize
    ./configure --with-php-config=$php_root/bin/php-config
    make -j 4
    make install
}

function install_php7()
{
    cd $cwd
    if [ ! -e "${php7}.tar.gz" ]; then
        wget -O ${php7}.tar.gz "http://cn2.php.net/distributions/${php7}.tar.gz"
    fi
    if [ ! -d $php7_root ]; then
        mkdir -p $php7_root
        tar zxf ${php7}.tar.gz
        cd $cwd/$php7
        './configure'  --prefix=$php7_root '--with-pdo-mysql=mysqlnd' '--with-mcrypt' '--with-gd' '--with-freetype-dir' '--with-jpeg-dir' '--with-png-dir' '--with-zlib-dir' '--with-libxml-dir' '--with-readline' '--enable-xml' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-inline-optimization' '--with-curl' '--enable-mbregex' '--enable-mbstring' '--enable-gd-native-ttf' '--enable-pcntl' '--enable-sockets' '--enable-soap' '--without-pear' '--enable-session' '--enable-fpm' '--with-fpm-user=nginx' '--with-fpm-group=nginx' '--enable-zip' '--with-openssl'
    else
        cd $cwd/$php7
    fi
    make -j 2
    make install
    cp php.ini-production $php7_root/etc/php.ini
    cd $php7_root/lib
    ln -s ../etc/php.ini

    cd $php7_root/etc
    cp php-fpm.conf.default php-fpm.conf
    chown -R nginx:nginx $php7_root/etc/ $php7_root/lib/php.ini
    ln -s $php7_root $INSTALL_ROOT/php7
}

function install_php7_memcached
{
    memcached=memcached-3.0.3
    cd $ext_root
    tar zxf ${memcached}.tgz
    cd $memcached
    $php7_root/bin/phpize
    ./configure --with-php-config=$php7_root/bin/php-config --disable-memcached-sasl
    make -j 4
    make install
}

function install_php7_redis()
{
    redis=phpredis-3.1.1
    cd $ext_root
    tar zxf ${redis}.tar.gz
    cd $redis
    $php7_root/bin/phpize
    ./configure --with-php-config=$php7_root/bin/php-config
    make -j 4
    make install
}

#install_openssl
#install_libmemcached
#install_nginx

#centos
#sudo yum install libpng-devel libjpeg-devel gd libXpm-devel freetype-devel libmcrypt-devel readline-devel ncurses-devel zlib-devel bzip2-devel 
#debian/ubuntu
#sudo apt-get install libmcrypt-dev libfreetype6-dev libjpeg-dev libpng-dev libcurl4-openssl-dev libxml2-dev libreadline-dev

#install_php
#install_php_memcached
#install_php_redis

#install_php7
#install_php7_memcached
#install_php7_redis
