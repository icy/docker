## List of my Dockers

1. `supervisor`:
    To run multiple processes and to solve reaping problem.
    Support `cron`, basic `exim4` to delivery
    email inside/from container to the world, and a minimal `syslog`
    implementation to catch application events;
1. `phantomjs`: To run `phantomjs-1.9.8`;
1. `tomcat`: Support `tomcat-7` application on `Debian/stable` system;
1. `redis`: Daemonize `redis-2.8.20`;
1. `percona`: To run `percona-5.6` daemon.
1. `nginx`: Hardened nginx;
1. `wordpress`: To run `wordpress` (any version). Use `phpfpm`;
1. `phpfpm`: A base library to start `phpfpm` daemon;
1. `btsync`: To run `btsync-1.3`.

## Build instruction

There isn't any `Dockerfile`. Because this project heavily uses
`Bockerfile`. A compiler script will generate `Dockerfile` for you.

The compiler is `bocker.sh` script. It comes from `bocker` project
(https://github.com/icy/bocker), which is a submodule of this repository.

      $ git clone https://github.com/icy/docker.git
      $ git submodules update --init

Now, if you want to have `Dockerfile` for `percona`, go to `context/`
directory and run `bocker.sh`:

      $ cd context/
      $ ../compiler/bocker.sh \
          ../bocker/Dockerfile.percona > Dockerfile.percona

      # You shouldn't see any warning/error from `bocker.sh`.
      # Now you are ready to build with the generated Dockerfile

      $ docker build -t you/percona -f Dockerfile.percona .

## License. Author

This work is published under a MIT license.

The author is Anh K. Huynh.
