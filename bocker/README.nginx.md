## A custom nginx

This `docker` image is to provide a custom `nginx`. Properties

* The latest stable `nginx-1.8.0`
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
* `/etc/nginx/sites/*`: Your sites are here
* `/etc/nginx/nginx.conf`: A global file. You may not need to custom it.

See the `Important notes` section for some details.

## Important notes

If you have some `nginx` proxy settings whose upstream address is
`127.0.0.1`, you will need to replace that address by the `docker` host
address or something similar. This is because you only see a `connection
refused` error when making connection to `127.0.0.1` from within a docker.

## Example usage

This is a screenshot

````
$ cd docker/

$ bocker ../bocker/Bockerfile           > Dockerfile.nginx
$ bocker ../bocker/Bockerfile.phpfpm    > Dockerfile.phpfpm
$ bocker ../bocker/Bockerfile.wordpress > Dockerfile.wordpress

$ docker build -t nginx     -f Dockerfile.nginx .
$ docker build -t phpfpm    -f Dockerfile.phpfpm .
$ docker build -t wordpress -f Dockerfile.wordpress .

$ docker run -d -P nginx
$ docker ps | grep nginx

$ docker ps
CONTAINER ID  IMAGE        COMMAND      ... PORTS                 ...
4727aa1286d9  nginx:latest "/nginx.sh"  ... 0.0.0.0:49170->80/tcp ...

$ curl -L localhost:49170/ping
pong
````

## Author. License

The author is Anh K. Huynh. The work is released a MIT license.
