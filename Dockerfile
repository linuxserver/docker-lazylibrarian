# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG LAZYLIBRARIAN_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

ARG UNRAR_VERSION=6.1.7

RUN \
  echo "**** install build packages ****" && \
  apt-get update && \
  apt-get install -y \
    libjpeg-turbo8-dev \
    python3-pip \
    zlib1g-dev && \
  echo "**** install runtime packages ****" && \
  apt-get install -y \
    ghostscript \
    libjpeg-turbo8 \
    libmagic1 \
    python3-minimal \
    python3-openssl \
    zlib1g && \
  echo "**** install unrar from source ****" && \
  mkdir /tmp/unrar && \
  curl -o \
    /tmp/unrar.tar.gz -L \
    "https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz" && \
  tar xf \
    /tmp/unrar.tar.gz -C \
    /tmp/unrar --strip-components=1 && \
  cd /tmp/unrar && \
  make && \
  install -v -m755 unrar /usr/bin && \
  echo "**** install app ****" && \
  mkdir -p \
    /app/lazylibrarian && \
  if [ -z ${LAZYLIBRARIAN_COMMIT+x} ]; then \
    LAZYLIBRARIAN_COMMIT=$(curl -sX GET "https://gitlab.com/api/v4/projects/9317860/repository/commits/master" \
      | awk '/id/{print $4;exit}' FS='[""]'); \
  fi && \
  echo "Installing from commit ${LAZYLIBRARIAN_COMMIT}" && \
  echo "${LAZYLIBRARIAN_COMMIT}" > /defaults/version.txt && \
  curl -o \
    /tmp/lazylibrarian.tar.gz -L \
    "https://gitlab.com/LazyLibrarian/LazyLibrarian/-/archive/{$LAZYLIBRARIAN_COMMIT}/LazyLibrarian-{$LAZYLIBRARIAN_COMMIT}.tar.gz" && \
  tar xf \
    /tmp/lazylibrarian.tar.gz -C \
    /app/lazylibrarian --strip-components=1 && \
  cd /app/lazylibrarian && \
  pip3 install -U --no-cache-dir \
    pip \
    wheel && \
  pip3 install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/ubuntu/ . && \
  echo "**** cleanup ****" && \
  apt-get -y purge \
    libjpeg-turbo8-dev \
    python3-pip \
    zlib1g-dev && \
  apt-get -y autoremove && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /root/.cache

# add local files
COPY root/ /

# ports and volumes
EXPOSE 5299
VOLUME /config
