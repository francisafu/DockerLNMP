# DockerLNMP

A docker image of Ubuntu, PHP, Nginx, Mysql and NodeJS for development use.

## Warining

This is an image built for **developing environment** ONLY!

THIS IMAGE SHOULD **NOT** BE USED IN ANY PRODUCTION ENVIRONMENT!!!

## Version

* Ubuntu 20.04 LTS
* PHP 7.4.3
* XDebug 3.1.6
* Composer 2.5.1
* Nginx 1.22.1
* Mysql 8.0.32
* NodeJS 18.13.0
* NPM 8.19.3

## PHP Extensions

calendar, Core, ctype, curl, date, dom, exif, FFI, fileinfo, filter, ftp, gd, gettext, hash, iconv, json, libxml, mbstring, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_mysql, Phar, posix, readline, Reflection, session, shmop, SimpleXML, sockets, sodium, SPL, standard, sysvmsg, sysvsem, sysvshm, tokenizer, xdebug, xml, xmlreader, xmlwriter, xsl, Zend OPcache, zip, zlib.

## Usage

```bash
docker pull francisafu/lnmp
docker run -dit --privileged=true -p 80:80 -p 443:443 -v /your/web/path:/var/www/  --name=lnmp francisafu/lnmp
```
## Notice

* Mirror source of Ubuntu has set to 'mirror://mirrors.ubuntu.com/mirrors.txt' which is auto search, you can change it with command:
  ```
  sed -i 's@mirror://mirrors.ubuntu.com/mirrors.txt@http://archive.ubuntu.com/ubuntu/@' /etc/apt/sources.list
  sed -i 's@mirror://mirrors.ubuntu.com/mirrors.txt@http://security.ubuntu.com/ubuntu/@' /etc/apt/sources.list
  ```
* Time zone has set to Asia/Shanghai(UTC+8), you can change it by yourself with command `dpkg-reconfigure tzdata`.  
* The password of Mysql Server user 'root@localhost' has set to '123456', you can change it with command `mysqladmin -u root -p password "YourNewPassword"` and enter the old one (123456).
* The config files listed below are all backed up in their own position with suffix '.back':
  * /etc/nginx/conf.d/default.conf
  * /etc/nginx/nginx.conf
  * /etc/php/7.4/fpm/php.ini
  * /etc/php/7.4/fpm/pool.d/www.conf
  * /etc/apt/sources.list
* The default shell of Ubuntu, which is dash, has switched to bash. You can change it back to dash with command `dpkg-reconfigure dash` and type 'yes'.

## Source Code

All source code available at https://github.com/francisafu/DockerLNMP.

Source code is under MIT License.