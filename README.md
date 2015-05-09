## List of my Dockers

## Useful for everyone

`supervisor` is the based image for all other images in this section.

7. `supervisor`:
    To run multiple processes and to solve reaping problem.
    Support `cron`, basic `exim4` to delivery
    email inside/from container to the world, and a minimal `syslog`
    implementation to catch application events.
4. `phantomjs`: To run `phantomjs-1.9.8`
6. `tomcat`: Support `tomcat-7` application on `Debian/stable` system
10. `redis`: Daemonize `redis-2.8.20`
11. `percona`: To run `percona-5.6` daemon.

## Other boring build files

1. `nginx`: Hardened nginx.

## Various Docker bugs

9. `bugs/chmod_bug`: A problem with `Docker-1.6-4749651`
10. `bugs/chmod_s_bug`: A problem with `Docker/aufs`
11. `bugs/copy_bug`: A missing feature of `Docker`.

## Personal. May not useful for everyone.

1. `pacapt`: A simple Docker image to add `pacapt` to a Debian image.
2. `aftershot`: To run `aftershot pro 1.2`
3. `nginx`: A fancy custom `nginx` image to use with `Puppet`, `Chef`, ...
5. `btsync`: To run `btsync-1.3`
8. `life`: A container for everything

## License

This work is published under a MIT license.
