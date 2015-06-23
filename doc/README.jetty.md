## Jetty Buildfile for Docker

Provide `Jetty-9.2` daemon.

By default, the image will have `jetty` installed in `/jetty`/ folder,
and the base directory is `/jetty/var/`. For new deployment, please
your application under `/jetty/var/webapps/` directory.

## Environments

* `JETTY_UID`: The `uid` of `jetty` account. Default: `10008`;
* `JETTY_GID`: The `guid` of `jetty` account. Default: `10008`;
* `JETTY_LOGS`: When `jetty` saves logs. Default: `/jetty/logs/`;
* `JETTY_ARGS`: Extra options for `jetty`. Default: (empty);
* `JAVA_OPTIONS`: Extra options for `java` daemon. Default: (empty);

## Exposed ports

* `8080`: the common port for `jetty`

## Support new version

Using `ed_reuse` from `Bocker` and redefine `ed_env` method, which
is by default

    ed_jetty_env() {
      export JETTY_VERSION="9.2.11.v20150529"
      export JETTY_CHECKSUM="d1f9970a8741bacd910b44754f86b1234ef4a076"
      export JETTY_URL="..."
    }

See an example of `bocker` overloading from `Bockerfile.nginx_mainline`.

## Usage

It's very easy after you build the image

    $ cd context/
    $ bocker ../bocker/Bockerfile.jetty > Dockerfile.jetty
    $ docker build -t jetty -f Dockerfile.jetty .
    $ docker run -p 8080:8080 -d --name jetty jetty
    $ curl http://localhost:8080/ -LIv
