## Phantomjs-1.9.x build file for Docker

The container will run `phantomjs` as `phantomjs` account.
The process listens on `8190` port (internally), and will use
fonts from `/usr/share/fonts/` (exportable as a volume.)

## Environment(s)

* `PHANTOMJS_DEBUG`: Turn debug on or off. Default: `false`.
* `PHANTOMJS_UID`: The `uid` of `phantomjs` account.
* `PHANTOMJS_GID`: The `gid` of `phantomjs` account.

## Expose port

* `8190`: The port for `API` use.

## Usage example

It's easy. You may need to add fonts into the volume.

    $ cd docker/

    $ bocker ../bocker/Bockerfile.phantomjs > Dockerfile.phantomjs

    $ docker build -t phantomjs -f Dockerfile.phantomjs .

    $ docker run -p 1234:8190 -d phantomjs

Now you are ready to connect to `:1234` on the host machine for testing.

By default, `debug` mode is disabled. You may need that:

    $ docker run -e PHANTOMJS_DEBUG=true -p 1234:8190 -d phantomjs

If you add new fonts to `/usr/share/fonts/`, remember to restart the
container, because a `fc-cache` command needs to be executed.
