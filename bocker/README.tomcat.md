## Tomcat Buildfile for Docker

Because people often runs `Tomcat` application as `root`,
`Docker` is a very good choice.

## Environments

* `TOMCAT_EXTRA`: extra arguments (e.g, memory settings) for `java`.
* `TOMCAT_UID`: The `uid` of `tomcat` account.
* `TOMCAT_GID`: The `gid` of `tomcat` account.

## Volumes

* `/tomcat/logs/`: where `tomcat` writes its logs
* `/tomcat/conf/`: global configuration for `tomcat`
* `/tomcat/webapps/`: path to your web applications. There are two
    default things: `manager` and `host-manager`

## Exposed ports

* `8080`: the common port for `tomcat`. If you update any configuration
  from `/tomcat/conf/server.xml`, you need to use this port. Otherwise,
  container linking may not work

## Usage

It's very easy after you build the image

    $ git clone https://github.com/icy/docker.git

    $ cd docker/docker
    $ bocker ../bocker/Bockerfile.tomcat > Dockerfile.tomcat

    $ docker build -t tomcat -f Dockerfile.tomcat .

    $ docker run -p 8080:8080 -d --name tomcat tomcat
    $ curl http://localhost:8080/ -LIv
