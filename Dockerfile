FROM lsiobase/alpine.python:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	make && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	ghostscript && \
 echo "***** build unrarlib ****" && \
 rar_ver=$(apk info unrar | grep unrar- | cut -d "-" -f2 | head -1) && \
 mkdir -p \
	/tmp/unrar && \
 curl -o \
 /tmp/unrar-src.tar.gz -L \
	"http://www.rarlab.com/rar/unrarsrc-${rar_ver}.tar.gz" && \
 tar xf \
 /tmp/unrar-src.tar.gz -C \
	/tmp/unrar --strip-components=1 && \
 cd /tmp/unrar && \
 make lib && \
 make install-lib && \
 echo "**** install app ****" && \
 git clone --depth 1 https://gitlab.com/LazyLibrarian/LazyLibrarian.git /app/lazylibrarian && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 5299
VOLUME /config /books /downloads
