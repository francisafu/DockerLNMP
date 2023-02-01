FROM ubuntu:20.04
LABEL author=FrancisFu

ENV DEBIAN_FRONTEND=noninteractive
ADD * /home/
WORKDIR /home

RUN cp /etc/apt/sources.list /etc/apt/sources.list.back && \
    sed -i 's@http://archive.ubuntu.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@' /etc/apt/sources.list && \
    sed -i 's@http://security.ubuntu.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@' /etc/apt/sources.list && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    apt -y update && \
    apt -y install curl unzip wget && \
    # Install PHP7.4 and Extentions
    apt -y install php7.4 php7.4-mysql php7.4-curl php7.4-xml php7.4-json php7.4-fpm php7.4-gd php7.4-mbstring php7.4-zip php7.4-dev && \
    wget https://xdebug.org/files/xdebug-3.1.6.tgz --no-check-certificate && \
    tar -xvzf xdebug-3.1.6.tgz && \
    cd xdebug-3.1.6 && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    # Install Nginx
    apt -y install gnupg2 ca-certificates lsb-release ubuntu-keyring && \
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list && \
    apt -y update && \
    apt -y install nginx && \
    # Install MySql
    apt -y install mysql-server && \
    service mysql stop && \
    usermod -d /var/lib/mysql/ mysql && \
    chmod -R 755 /var/run/mysqld && \
    cp /etc/mysql/mysql.cnf /etc/mysql/my.cnf && \
    echo '[mysqld]\nskip-grant-tables' >> /etc/mysql/my.cnf && \
    service mysql restart && \
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456';" && \
    mysql -e "flush privileges;" && \
    head -n -2 /etc/mysql/my.cnf > temp.cnf && \
    mv temp.cnf /etc/mysql/my.cnf && \
    service mysql stop && \
    # Copy Configuration Files
    cp /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.back && \
    cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.back && \
    cp /etc/php/7.4/fpm/php.ini /etc/php/7.4/fpm/php.ini.back && \
    cp /etc/php/7.4/fpm/pool.d/www.conf /etc/php/7.4/fpm/pool.d/www.conf.back && \
    cp /home/default.conf /etc/nginx/conf.d/default.conf && \
    cp /home/nginx.conf /etc/nginx/nginx.conf && \
    cp /home/php.ini /etc/php/7.4/fpm/php.ini && \
    cp /home/www.conf /etc/php/7.4/fpm/pool.d/www.conf && \
    # Services Auto Start
    sed -i '1s/^/service nginx start\n/' ~/.bashrc && \
    sed -i '1s/^/service mysql start\n/' ~/.bashrc && \
    sed -i '1s/^/service php7.4-fpm start\n/' ~/.bashrc && \
    sed -i '1s/^/#auto start\n/' ~/.bashrc && \
    rm -rf /home/* && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/www && \
    chown -R www-data:www-data /var/www

EXPOSE 443 80
VOLUME ["/var/www"]

# 可用性
# 删除/var/log/mysql/error.log
# 精简镜像