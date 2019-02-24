[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).

# PSA: Changes are happening

From August 2018 onwards, Linuxserver are in the midst of switching to a new CI platform which will enable us to build and release multiple architectures under a single repo. To this end, existing images for `arm64` and `armhf` builds are being deprecated. They are replaced by a manifest file in each container which automatically pulls the correct image for your architecture. You'll also be able to pull based on a specific architecture tag.

TLDR: Multi-arch support is changing from multiple repos to one repo per container image.

# [linuxserver/lazylibrarian](https://github.com/linuxserver/docker-lazylibrarian)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/lazylibrarian.svg)](https://microbadger.com/images/linuxserver/lazylibrarian "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/lazylibrarian.svg)](https://microbadger.com/images/linuxserver/lazylibrarian "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/lazylibrarian.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/lazylibrarian.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-lazylibrarian/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-lazylibrarian/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/lazylibrarian/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/lazylibrarian/latest/index.html)

[Lazylibrarian](https://github.com/DobyTang/LazyLibrarian) is a program to follow authors and grab metadata for all your digital reading needs. It uses a combination of Goodreads Librarything and optionally GoogleBooks as sources for author info and book info.  This container is based on the DobyTang fork.


[![lazylibrarian](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/lazylibrarian-icon.png)](https://github.com/DobyTang/LazyLibrarian)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list). 

Simply pulling `linuxserver/lazylibrarian` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v6-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=lazylibrarian \
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=Europe/London \
  -p 5299:5299 \
  -v <path to data>:/config \
  -v <path to downloads>:/downloads \
  -v <path to data>:/books \
  --restart unless-stopped \
  linuxserver/lazylibrarian
```


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  lazylibrarian:
    image: linuxserver/lazylibrarian
    container_name: lazylibrarian
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Europe/London
    volumes:
      - <path to data>:/config
      - <path to downloads>:/downloads
      - <path to data>:/books
    ports:
      - 5299:5299
    mem_limit: 4096m
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 5299` | The port for the LazyLibrarian webinterface |
| `-e PUID=1001` | for UserID - see below for explanation |
| `-e PGID=1001` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use e.g. Europe/London |
| `-v /config` | LazyLibrarian config |
| `-v /downloads` | Download location |
| `-v /books` | Books location |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```
  $ id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```


&nbsp;
## Application Setup

Access the webui at `http://<your-ip>:5299/home`, for more information check out [Lazylibrarian](https://github.com/DobyTang/LazyLibrarian).



## Support Info

* Shell access whilst the container is running: `docker exec -it lazylibrarian /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f lazylibrarian`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' lazylibrarian`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/lazylibrarian`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/lazylibrarian`
* Stop the running container: `docker stop lazylibrarian`
* Delete the container: `docker rm lazylibrarian`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start lazylibrarian`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update the image: `docker-compose pull linuxserver/lazylibrarian`
* Let compose update containers as necessary: `docker-compose up -d`
* You can also remove the old dangling images: `docker image prune`

## Versions

* **22.02.19:** - Rebasing to alpine 3.9.
* **10.12.18:** - Moved to Pipeline Building
* **16.08.18:** - Rebase to alpine 3.8
* **05.01.18:** - Deprecate cpu_core routine lack of scaling
* **12.12.17:** - Rebase to alpine 3.7
* **21.07.17:** - Internal git pull instead of at runtime
* **25.05.17:** - Rebase to alpine 3.6
* **07.02.17:** - Rebase to alpine 3.5
* **30.01.17:** - Compile libunrar.so to allow reading of .cbr format files
* **12.01.17:** - Add ghostscript package, allows magazine covers to be created etc
* **14.10.16:** - Add version layer information
* **03.10.16:** - Fix non-persistent settings and make log folder
* **28.09.16:** - Inital Release
