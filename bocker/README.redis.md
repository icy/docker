## Redis-2.8.20 build support for Docker

The result container will run `redis` thanks to `supervisor`.

## Environment(s)

* `REDIS_UID`: The `uid` of `redis` account. Default: `10002`.
* `REDIS_GID`: The `gid` of `redis` account. Default: `10002`.
* `REDIS_LOGLEVEL`: Logging level Default: `warning`.
* `REDIS_APPENDONLY`: Use of persistent storage backend. Default: `yes`.

## Exposed ports

* `6379`: The popular `redis` port

## Notes:

`REDIS_APPENDONLY` should be `yes` so that `redis` data (`/redis/`)
can be mounted on another container.

## Build instruction

It's easy.

    $ cd docker/
    $ bocker ../bocker/Bockerfile.redis > Dockerfile.redis
    $ docker build -t redis -f Dockerfile.redis .

## Configuration file

The default file is `/redis/redis-2.8.conf`. You can specify your own
configuration by Docker mounting feature.
