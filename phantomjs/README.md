## Phantomjs-1.9.x build file for Docker

The container will run `phantomjs` as `phantomjs` account.
The process listens on `8190` port (internally), and will use
fonts from `/usr/share/fonts/` (exportable as a volume.)

## Environment(s)

* `PHANTOMJS_DEBUG`: Turn debug on or off. Default: `false`.

## Usage example

It's easy. You may need to add fonts into the volume.

    $ cd phantomjs/ && docker build -t phantomjs .
    $ docker run -p 1234:8190 -d phantomjs

Now you are ready to connect to `:1234` on the host machine for testing.

If you add new fonts to `/usr/share/fonts/`, remember to restart the
container, because a `fc-cache` command needs to be executed.
