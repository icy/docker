## A custom nginx

This `docker` image is to provide a custom `nginx`. Properties

* The latest stable `nginx-1.6.2`
* Hide all `nginx` signatures from its reponse (`4xx` error pages,
    server header, ...)
* Standard modules:
    `ssl`, `stub_status`, `realip`,
    `gzip_static`, `sub`, `echo`, `headers-more`
* Fancy directory structure in `/etc/nginx/` _(see next section for details)_.

## /etc/nginx/

No more `sites-available` and `sites-enabled`!

* `/etc/nginx/conf.d/*.core`: Core settings for `nginx`
* `/etc/nginx/conf.d/*.http`: Basic settings for `HTTP` web server
* `/etc/nginx/misc`: Some useful examples
* `/etc/nginx/sites/ping.conf`: The `catch-all` site, which provides
    `/ping` to your Elastic Load Balancing
* `/etc/nginx/nginx.conf`: A global file. You may not need to custom it.

## Example usage

This is a screenshot

````
$ cd icy-docker/nginx/
$ docker build -t nginx .
$ docker run -d -P nginx
$ docker ps | grep nginx

$ docker ps
CONTAINER ID  IMAGE        COMMAND      ... PORTS                 ...
4727aa1286d9  nginx:latest "/nginx.sh"  ... 0.0.0.0:49170->80/tcp ...

$ curl -vL localhost:49170/ping
*   Trying 127.0.0.1...
* Connected to localhost (127.0.0.1) port 49170 (#0)
> GET /ping HTTP/1.1
> User-Agent: curl/7.41.0
> Host: localhost:49170
> Accept: */*
>
< HTTP/1.1 200 OK
< Date: Fri, 03 Apr 2015 09:17:41 GMT
< Content-Type: application/octet-stream
< Transfer-Encoding: chunked
< Connection: close
< Server: Apache
< X-Powered-By: Linux
<
pong
* Closing connection 0

````

## Author. License

The author is Anh K. Huynh. The work is released a MIT license.
