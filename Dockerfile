FROM lsiobase/alpine.python
MAINTAINER chbmb

# add local files
COPY root/ /

# ports and volumes
VOLUME /config
EXPOSE 5299
