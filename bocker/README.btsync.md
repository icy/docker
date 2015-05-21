## btsync-1.3 buildfile for Docker

`btsync-1.3` is a great software with clean UI and simple idea.

There are now `btsync-1.4`, `btsync-2.0`. They are for professional
users who like a messy `UI` and dummy stupid functions.

We are only novice users.

## Environments

* `BTSYNC_NAME`: the device name. Default: Container hostname
* `BTSYNC_PASSWD`: the password of `admin` account. Default: Random
* `BTSYNC_INTERVAL`: folder scanning interval. Default: 300 seconds
* `BTSYNC_DEBUG`: Debug flags. Default: `FF` (a lot of information!)

## Volume

* `/btsync/`: contains all `btsync` data (`/btsync/var`) and user's
  directories (`/btsync/sync`.)

## Usage

When the container is started, it will listen on `8888` (`webui`)
and `8881` (`data`) ports. A random password is generated and written
to the `docker` logs, unless you specify one with `BTSYNC_PASSWD`
environment.

The data volume (`/btsync/`) contains all `btsync` variant files
and synchornization folders.
