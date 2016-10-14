FROM lsiobase/alpine.python
MAINTAINER chbmb

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# add local files
COPY root/ /

# ports and volumes
EXPOSE 5299
VOLUME /config /books /downloads
