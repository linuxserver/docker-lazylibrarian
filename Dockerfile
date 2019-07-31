FROM lsiobase/ubuntu:bionic

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
	git \
	python3-pip && \
 echo "**** install runtime packages ****" && \
 apt-get install -y \
	ghostscript \
	python3-minimal \
	python3-openssl \
	unrar && \
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
 cd /app/lazylibrarian && \
 pip3 install --no-cache-dir -U \
	apprise && \
 echo "**** cleanup ****" && \
 apt-get -y purge \
	git \
	python3-pip && \
 apt-get -y autoremove && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*
    
# add local files
COPY root/ /

# ports and volumes
EXPOSE 5299
VOLUME /books /config
