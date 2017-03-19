FROM ubuntu:latest

MAINTAINER Vo Anh Kiet <zvoanhkietz@gmail.com>

ARG user=vkiet
ARG group=vkiet
ARG uid=1000
ARG gid=1000
ARG pas=123456

# install packages
RUN \
  apt-get update && \
  apt-get install -y sudo \
          vim \
          git \
          curl \
          php7.0 \
          php7.0-xml \
          php7.0-mysql \
          php7.0-pdo \
          php7.0-mbstring \
          php7.0-intl \
          php7.0-zip \
          php7.0-sqlite \
          php7.0-sqlite3 \
          php-xdebug \
          mysql-client

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server


# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# disable xdebug when using composer
ENV COMPOSER_ALLOW_XDEBUG 0
ENV COMPOSER_DISABLE_XDEBUG_WARN 1

# create new sudo user
RUN groupadd -g ${gid} ${group}
RUN useradd -u ${uid} -g ${gid} -m -d "/home/${user}" -s /bin/bash -p"${pas}" ${user}
RUN sudo usermod -aG sudo ${user}
RUN echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p "/home/${user}/Projects"
RUN chown -R "${user}:${group}" "/home/${user}/Projects"

VOLUME ["/home/${user}/.ssh" ,"/home/${user}/Projects"]

EXPOSE 80

USER ${user}

