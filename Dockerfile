FROM scratch
LABEL \
    org.opencontainers.image.title="Ubuntu 22.04 LTS (Jammy Jellyfish)" \
    org.opencontainers.image.release="jammy" \
    org.opencontainers.image.architecture="amd64" \
    org.opencontainers.image.variant="default" \
    org.opencontainers.image.created="20250320" \
    maintainer="localhost"

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=en_US.UTF8 \
    LC_ALL=en_US.UTF8 \
    LANGUAGE=enUS:en

ADD ubuntu-base-22.04-base-amd64.tar.gz /
#ADD sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends tzdata language-pack-en \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime  \
    && echo $TZ > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y \
    php php-mysql php-fpm php-gd php-json php-xml php-mbstring php-curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


EXPOSE 80/tcp
WORKDIR /var/www/html
COPY default /etc/nginx/sites-available/default

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
