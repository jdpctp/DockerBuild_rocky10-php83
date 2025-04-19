# 使用Rocky Linux 9為基底
FROM rockylinux/rockylinux:9-minimal

# 加入動態日期，讓緩存失效
ARG BUILD_DATE
RUN echo "Build date: $BUILD_DATE"

# 更新所有套件，強制刷新元數據
RUN microdnf clean all && microdnf -y update --refresh && microdnf -y upgrade

# 更新所有套件
#RUN microdnf -y update && microdnf -y upgrade

# 安裝EPEL及remi repo
#RUN microdnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN rpm -ivh https://rpms.remirepo.net/enterprise/remi-release-9.rpm


#RUN microdnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm
#    microdnf install -y microdnf-plugins-core && \
#    microdnf config-manager --set-enabled remi-php83

# 更新元數據
RUN microdnf -y update

# 安裝Microsoft ODBC Driver for SQL Server on Linux
#RUN curl https://packages.microsoft.com/config/rhel/9/prod.repo | tee /etc/yum.repos.d/mssql-release.repo && \
#    ACCEPT_EULA=Y microdnf install -y msodbcsql17

# 安裝PHP 8.3及相關套件
RUN microdnf install -y php83-php php83-php-fpm php83-php-gd php83-php-mbstring php83-php-opcache php83-php-zip php83-php-intl php83-php-xmlrpc php83-php-soap php83-php-mysqli php83-php-pecl-redis6

RUN microdnf install -y net-tools telnet iputils iproute

# 清理暫存檔案
RUN microdnf -y clean all

# 設置 PHP-FPM 配置
#RUN set -eux; \
#    cd /etc/opt/remi/php83/php-fpm.d; \
#    { \
#        echo '[global]'; \
#        echo 'daemonize = no'; \
#        echo 'error_log = /proc/self/fd/2'; \
#        echo; \
#        echo '[www]'; \
#        echo 'listen = 9000'; \
#        echo 'access.log = /proc/self/fd/2'; \
#        echo 'clear_env = no'; \
#        echo 'catch_workers_output = yes'; \
#        echo 'decorate_workers_output = no'; \
#    } | tee zz-docker.conf;

# 設置 PHP-FPM 配置目錄
RUN mkdir -p /etc/opt/remi/php83/php-fpm.d /var/opt/remi/php83/run/php-fpm && \
    chown -R 1000:1000 /var/opt/remi/php83/run/php-fpm

# 確保緩存目錄存在並設置權限
RUN mkdir -p /var/cache/yum && \
    chown -R 1000:1000 /var/cache/yum

ENV PATH="/opt/remi/php83/root/usr/sbin:$PATH"

# 暴露端口
EXPOSE 9000

# 使用docker Account
USER 1000:1000

# 將PHP-FPM以前景模式運行
CMD ["php-fpm", "-F", "--nodaemonize"]
