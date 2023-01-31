FROM ubuntu:20.04
LABEL author=FrancisFu

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /home

RUN cp /etc/apt/sources.list /etc/apt/sources.list.back && \
    sed -i 's@http://archive.ubuntu.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@' /etc/apt/sources.list && \
    sed -i 's@http://security.ubuntu.com/ubuntu/@mirror://mirrors.ubuntu.com/mirrors.txt@' /etc/apt/sources.list && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    groupadd www && \
    useradd -g www www && \
    apt -y update && \
    apt -y install curl unzip wget && \
    apt -y install php7.4 php7.4-mysql php7.4-curl php7.4-xml php7.4-json php7.4-fpm php7.4-gd php7.4-mbstring php7.4-zip php7.4-dev && \
    wget https://xdebug.org/files/xdebug-3.1.6.tgz --no-check-certificate && \
    tar -xvzf xdebug-3.1.6.tgz && \
    cd xdebug-3.1.6 && \
    phpize && \
    ./configure && \
    make && \
    make install && \
    rm xdebug-3.1.6.tgz && \
    rm -r xdebug-3.1.6 && \
    apt -y install curl gnupg2 ca-certificates lsb-release ubuntu-keyring && \
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list && \
    apt -y update && \
    apt -y install nginx && \
    apt -y install mysql-server && \
    sed -i '1s/^/service nginx start\n/' ~/.bashrc && \
    sed -i '1s/^/service mysql start\n/' ~/.bashrc && \
    sed -i '1s/^/service php7.4-fpm start\n/' ~/.bashrc && \
    sed -i '1s/^/#auto start\n/' ~/.bashrc && \
    chown -R www:www /var/www/ && \
    service php7.4-fpm start && \
    service nginx start && \
    service mysql start

EXPOSE 443 80
VOLUME ["/var/www"]
