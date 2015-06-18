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

* `8080`: the common port for `tomcat`. If you update any configuration
  from `/tomcat/conf/server.xml`, you need to use this port. Otherwise,
  container linking may not work.

## Notes

To reload a context, e.g, `/mycontext`, use the following command

    $ /bocker.sh ed_tomcat_reload_context /mycontext

See also the definition of `ed_tomcat_reload_context`.

## Usage

It's very easy after you build the image

    $ cd context/
    $ bocker ../bocker/Bockerfile.tomcat > Dockerfile.tomcat
    $ docker build -t tomcat -f Dockerfile.tomcat .
    $ docker run -p 8080:8080 -d --name tomcat tomcat
    $ curl http://localhost:8080/ -LIv
