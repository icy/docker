## Possibly a bug of Docker 1.6-4749651

It's impossible to create symbolic link
on an external volume.

It's impossible to fix the file permission
on an external volume.

## Reproduce the problem

Build the `icy/empty` image

    $ cd bugs/empty && docker build -t icy/empty .

Build the `icy/chmod_bug` image

    $ cd bugs/chmod_bug && docker build -t icy/chmod_bug .

Now create a new container

    $ docker run -ti --rm icy/chmod_bug
    total 4
    -rw-r--r-- 1 314 314 213 Apr 25 05:40 chmod.sh

    Expected results

      chmod.sh:           should has permission 755
      this_will_fail.sh:  should exist

      What have you ever seen in the result of 'ls' command?

## My environment

It's `docker-1.6` on `ArchLinux`

  $ docker info
  Containers: 2
  Images: 308
  Storage Driver: devicemapper
   Pool Name: docker-8:4-9437191-pool
   Pool Blocksize: 65.54 kB
   Backing Filesystem: extfs
   Data file: /dev/loop0
   Metadata file: /dev/loop1
   Data Space Used: 4.391 GB
   Data Space Total: 107.4 GB
   Data Space Available: 103 GB
   Metadata Space Used: 11.03 MB
   Metadata Space Total: 2.147 GB
   Metadata Space Available: 2.136 GB
   Udev Sync Supported: true
   Data loop file: /home/locker/data/devicemapper/devicemapper/data
   Metadata loop file: /home/locker/data/devicemapper/devicemapper/metadata
   Library Version: 1.02.93 (2015-01-30)
  Execution Driver: native-0.2
  Kernel Version: 3.18.6-1-ARCH
  Operating System: Arch Linux
  CPUs: 4
  Total Memory: 3.563 GiB
  Name: icy
  ID: xxx:xxx:...
  WARNING: No swap limit support
