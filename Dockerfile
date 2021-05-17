FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG LAZYLIBRARIAN_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

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
    python3-minimal \
    python3-openssl \
    unrar \
    zlib1g && \
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
  pip3 install --no-cache-dir -U \
    pip && \
  pip install --no-cache-dir --find-links https://wheel-index.linuxserver.io/ubuntu/ -U \
    apprise \
    Pillow && \
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
VOLUME /books /config
