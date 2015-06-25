## Tomcat Buildfile for Docker

Because people often runs `Tomcat` application as `root`,
`Docker` is a very good choice.

## Environments

* `TOMCAT_EXTRA`: extra arguments (e.g, memory settings) for `java`;
* `TOMCAT_UID`: The `uid` of `tomcat` account;
* `TOMCAT_GID`: The `gid` of `tomcat` account;
* `TOMCAT_AUTO_DEPLOY`: Auto-deploy the application or not. Default: `false`;
* `TOMCAT_UNPACK_WAR`: Unpack `.war` file to application directory. Default: `true`;
* `TOMCAT_ADMIN_PASSWD`: The password of `admin` account of the
   `host manager` application. If this password is provided, the
   file `/tomcat/conf/tomcat-users.xml` will be updated.

## Exposed ports

* `8080`: the common port for `tomcat`

## Deployment notes

### Application paths

1. `/tomcat/`: the main directory;
1. `/tomcat/conf`: store all configuration files for `tomcat`;
1. `/tomcat/logs/`: where logs are stored; by default, all access logs
    are disabled; you will not intend to put your `tomcat` instance
    directly behind your firewall;
1. `/tomcat/webapps/*`: where your applications are mounted.
1. `/supervisor/tomcat_${HOSTNAME}.log`: where `supervisor` stores
    events from `STDOUT` and `STDERR` devices of running `tomcat` instance.

### Restart, reloading

1. To reload a context, e.g, `/mycontext`, use the following command

      $ /bocker.sh ed_tomcat_reload_context /mycontext

   If no argument is provided, the root context (`/`) will be reloaded;
1. To restart a running `tomcat` intsance, please use `s restart tomcat`,
   or `/bocker.sh ed_tomcat_restart`.

### How `tomcat` is started

The init script `/supervisor.sh` will try to fix some configuration files,
included `/tomcat/server.xml`, `/tomcat/tomcat-users.xml`, `/tomcat/logging.properties`.
The main things are

1. Disabling access log;
1. Fixing log prefixes, by using `catalina__${HOSTNAME}.` and `localhost_${HOSTNAME}`
   for log files under `/tomcat/logs/`. This is useful when you scale your
   infrastructure and share the same logging volumes between `tomcat` containers
1. Updating password of `admin` account of `host manager` application.
   The whole file `/tomcat/conf/tomcat-users.xml` will be updated,
   unless you make `TOMCAT_ADMIN_PASSWD` environment empty, and/or
   make that file `read-only`.

### Security notes

Unless you provide `TOMCAT_ADMIN_PASSWD`, the hots manager application
(`/manager/*`) is inaccessible. When it is enabled, you should use another
protection layer to make sure `/manager/` isn't visible by the world.

## Usage

It's very easy after you build the image

    $ cd context/
    $ bocker ../bocker/Bockerfile.tomcat > Dockerfile.tomcat
    $ docker build -t tomcat -f Dockerfile.tomcat .
    $ docker run -p 8080:8080 -d --name tomcat tomcat
    $ curl http://localhost:8080/ -LIv
