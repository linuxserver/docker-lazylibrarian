[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: https://github.com/DobyTang/LazyLibrarian
[hub]: https://hub.docker.com/r/linuxserver/lazylibrarian/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/lazylibrarian
[![](https://images.microbadger.com/badges/version/linuxserver/lazylibrarian.svg)](https://microbadger.com/images/linuxserver/lazylibrarian "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/linuxserver/lazylibrarian.svg)](https://microbadger.com/images/linuxserver/lazylibrarian "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/lazylibrarian.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/lazylibrarian.svg)][hub][![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Builders/x86-64/x86-64-lazylibrarian)](https://ci.linuxserver.io/job/Docker-Builders/job/x86-64/job/x86-64-lazylibrarian/)

[LazyLibrarian][appurl] is a program to follow authors and grab metadata for all your digital reading needs. It uses a combination of Goodreads Librarything and optionally GoogleBooks as sources for author info and book info.  This container is based on the DobyTang fork.

[![lazylibrarian](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/lazylibrarian-icon.png)][appurl]

## Usage

```
docker create \
  --name=lazylibrarian \
  -v <path to data>:/config \
  -v <path to data>:/downloads \
  -v <path to data>:/books \
  -e PGID=<gid> -e PUID=<uid>  \
  -e TZ=<timezone> \
  -p 5299:5299 \
  linuxserver/lazylibrarian
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`


* `-p 5299` - Port for webui
* `-v /config` Containers lazylibrarian config and database
* `-v /downloads` lazylibrarian download folder
* `-v /books` location of ebook library
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` for setting timezone information, eg Europe/London

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it lazylibrarian /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
Access the webui at `<your-ip>:5299/home`, for more information check out [LazyLibrarian][appurl]..

## Info

* To monitor the logs of the container in realtime `docker logs -f lazylibrarian`.

* container version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' lazylibrarian`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/lazylibrarian`

## Versions

+ **10.12.18:** Moved to Pipeline Building
+ **16.08.18:** Rebase to alpine 3.8.
+ **05.01.18:** Deprecate cpu_core routine lack of scaling.
+ **12.12.17:** Rebase to alpine 3.7.
+ **21.07.17:** Internal git pull instead of at runtime.
+ **25.05.17:** Rebase to alpine 3.6.
+ **07.02.17:** Rebase to alpine 3.5.
+ **30.01.17:** Compile libunrar.so to allow reading of .cbr format files.
+ **12.01.17:** Add ghostscript package, allows magazine covers to be created etc.
+ **14.10.16:** Add version layer information.
+ **03.10.16:** Fix non-persistent settings and make log folder.
+ **28.09.16:** Inital Release.
