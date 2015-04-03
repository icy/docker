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

## Author. License

The author is Anh K. Huynh. The work is released a MIT license.
