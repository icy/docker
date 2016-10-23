## btsync Buildfile for Docker

This documentation guides you to build Docker images for `btsync`
version `1.3`, `1.4` and `2.x`.

## Environments

* `BTSYNC_NAME`: the device name. Default: Container hostname
* `BTSYNC_PASSWD`: the password of `admin` account. Default: Random
* `BTSYNC_INTERVAL`: folder scanning interval. Default: 300 seconds
* `BTSYNC_DEBUG`: Debug flags. Default: `FF` (a lot of information!)

## Volume

* `/btsync/`: contains all `btsync` data (`/btsync/var`) and user's
  directories (`/btsync/sync`.)

## Build instruction

Compile `Dockerfile` from `Bockerfile` and then build Docker image

    $ git clone https://github.com/icy/docker.git icy-docker
    $ cd icy-docker/
    $ git submodule update --init
    # git submodule update --remote --checkout
    $ cd context/

    # For btsync-1.3
    $ ../compiler/bocker.sh \
          ../bocker/Bockerfile.btsync > Dockerfile.btsync13

    # For btsync-2.x
    $ ../compiler/bocker.sh \
          ../bocker/Bockerfile.btsync2 > Dockerfile.btsync2x

    # For btsync-1.4
    $ ../compiler/bocker.sh \
          ../bocker/Bockerfile.btsync14 > Dockerfile.btsync14

    # Now build your own Docker image
    $ docker build -t my_btsync13 -f Dockerfile.btsync13 .
    $ docker build -t my_btsync14 -f Dockerfile.btsync14 .
    $ docker build -t my_btsync2x -f Dockerfile.btsync2x .

    # See your results
    $ docker images | grep mine_btsync

## Usage

After you build `Docker` image, you can launch it, for example

    $ docker run -d --name btsync13 \
          -e "BTSYNC_PASSWD=foobar" \
          -e "BTSYNC_DEBUG=00" \
          -p "8888:8888" \
          -v $HOME/data/btsync13/sync/:/btsync/sync/ \
          -v $HOME/data/btsync13/var/:/btsync/var/ \
          my_btsync13

When the container is started, it will listen on `8888` (`webui`)
and `8889` (`data`) ports. A random password is generated and written
to the `docker` logs, unless you specify one with `BTSYNC_PASSWD`
environment.

The data volume (`/btsync/`) contains all `btsync` variant files
and synchornization folders.


## Important notes

1. Inside the container,
   the `btsync` daemon is running as `btsync` user whose `UID` is `1000`.
1. Don't use the same volume for different `btsync` containers.
   A data volume for `btsync` (seen as `/btsync/` in container per-se)
   can be upgraded, but it can't be downgraded. You have been warned.
1. Version 1.3 has very clean and simple `webUI`. However, it's very
  out-of-date. Use it at your own risk.
