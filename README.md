# docker-gc

A simple docker container and image garbage collection script from [spotify](https://github.com/spotify/docker-gc).

* Containers that exited more than an hour ago are removed.
* Images that don't belong to any remaining container after that are removed.

Although docker normally prevents removal of images that are in use by
containers, we take extra care to not remove any image tags (e.g. ubuntu:14.04,
busybox, etc) that are in use by containers. A naive `docker rmi $(docker images -q)`
will leave images stripped of all tags, forcing docker to re-pull the
repositories when starting new containers even though the images themselves are
still on disk.

This script is intended to be run as a cron job.


## Usage

You can find this image in the public registry [here](https://registry.hub.docker.com/u/iainmckay/docker-gc/).

To run the container you need to pass in the docker binary and socket file so that
we can remove containers from the host:

    $ docker run -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker iainmckay/docker-gc


## Excluding Images From Garbage Collection

There can be images that are large that serve as a common base for
many application containers, and as such, make sense to pin to the
machine, as many derivative containers will use it.  This can save
time in pulling those kinds of images.  There may be other reasons to
exclude images from garbage collection.  To do so, create
`/etc/docker-gc-exclude`, or if you want the file to be read from
elsewhere, set the `EXCLUDE_FROM_GC` environment variable to its
location.  This file can contain image name patterns (in the `grep`
sense), one per line, such as `spotify/cassandra:latest` or it can
contain image ids (truncated to the length shown in `docker images`
which is 12.

An example excludes file might contain:
```
spotify/cassandra:latest
9681260c3ad5
```
