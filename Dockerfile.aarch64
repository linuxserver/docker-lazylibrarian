FROM lsiobase/python:arm64v8-3.9

# set version label
ARG BUILD_DATE
ARG VERSION
ARG LAZYLIBRARIAN_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="chbmb"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	make && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
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
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
 	apprise && \
 echo "**** install app ****" && \
 mkdir -p \
	/app/lazylibrarian && \
 if [ -z ${LAZYLIBRARIAN_COMMIT+x} ]; then \
 	LAZYLIBRARIAN_COMMIT=$(curl -sX GET "https://gitlab.com/api/v4/projects/9317860/repository/commits/master" \
    	| awk '/id/{print $4;exit}' FS='[""]'); \
 fi && \
 echo "Building from commit ${LAZYLIBRARIAN_COMMIT}" && \
 echo "${LAZYLIBRARIAN_COMMIT}" > /defaults/version.txt && \
 curl -o \
 /tmp/lazylibrarian.tar.gz -L \
	"https://gitlab.com/LazyLibrarian/LazyLibrarian/repository/archive.tar.gz?sha={$LAZYLIBRARIAN_COMMIT}" && \
 tar xf \
 /tmp/lazylibrarian.tar.gz -C \
	/app/lazylibrarian --strip-components=1 && \
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
