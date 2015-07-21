## Fluentd Buildfile for Docker

Provide `td-agent` for `debian:wheezy`. Though the name is `fluentd`,
the image contains the stable version `td-agent`.

See http://docs.fluentd.org/ for details.

## Environments

* `FLUENTD_UID`: The `uid` of system account that starts `fluentd` daemon. Default: `10009`;
* `FLUENTD_GID`: The `gid` of system account that starts `fluentd` daemon. Default: `10009`;

## Directory

The main directory is `/fluentd` where default logs are stored.

When starting, the main script will locate if the file `/fluentd/agent.conf`
does exist; if not, a default file is generated. That file will be used
to launch the daemon.

## Exposed ports

* `8888`: the common port for `http` source.

## Usage

It's very easy after you build the image

    $ cd context/
    $ bocker ../bocker/Bockerfile.fluentd > Dockerfile.fluentd
    $ docker build -t fluentd -f Dockerfile.fluentd .
    $ docker run -p 8888:8888 -d --name fluentd fluentd
    $ curl -vX POST -d "json={\"json\":\"test\"}" http://localhost:888/debug.test
