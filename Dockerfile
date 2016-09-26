FROM lsiobase/alpine.python
MAINTAINER chbmb

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /logs
EXPOSE 5259
