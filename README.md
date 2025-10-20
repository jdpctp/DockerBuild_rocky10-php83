# DockerWeeklyBuild_rocky10-php83
Rocky Linux 10 minimal + php83-php-fpm (每週一dnf update，重新Build Docker Image)

docker-compose.yml
```
services:
  php83:
    container_name: php83
    image: ghcr.io/jdpctp/rocky10-php83:latest
    restart: unless-stopped
    user: 1000:1000
    volumes:
      - ./www:/www
      - ./php83/etc/php-fpm.conf:/etc/opt/remi/php83/php-fpm.conf
      - ./php83/etc/php.ini:/etc/opt/remi/php83/php.ini
      - ./php83/etc/php-fpm.d:/etc/opt/remi/php83/php-fpm.d
      - ./php83/var/lib/php:/var/opt/remi/php83/lib/php
      - ./php83/var/log:/var/opt/remi/php83/log
    ports:
      - 9000:9000
    environment:
      TZ: Asia/Taipei
