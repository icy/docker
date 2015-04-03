## List of my Dockers

1. `pacapt`: A simple Docker image to add `pacapt` to a Debian image.
2. `aftershot`: To run `aftershot pro 1.2`

## Quick start on ArchLinux

It's very easy to use `Docker` on `ArchLinux`.

    # Log in into your `root` shell.

    $ pacman -S docker
    $ mkdir -pv /home/locker/data/

Now create your custom `init` script in `systemd` style as below.
In the example, `/home/locker/data/` is where `docker` stores its data.
You can use your own custom directory.

    # File name: /etc/systemd/system/docker.service
    # File contents:
    [Unit]
    Description=Docker Application Container Engine
    Documentation=http://docs.docker.com
    After=network.target docker.socket
    Requires=docker.socket

    [Service]
    ExecStart=/usr/bin/docker -d -H fd:// -g /home/locker/data/
    LimitNOFILE=1048576
    LimitNPROC=1048576

    [Install]
    WantedBy=multi-user.target

You are almost ready

    $ systemctl enable docker
    $ systemctl start docker

You need to add yourself to `docker` group

    $ gpasswd -a YOUR_USERNAME docker
    $ exit
    # Exit from your `root` session and start with your shell

    # Log in into `docker` group
    $ newgrp docker

You need to check out this repository

    $ git clone https://github.com/icy/docker.git icy-docker
    $ cd icy-docker/pacapt
    $ docker build -t pacapt .

`Docker` will build a local image tagged with `pacapt`. After it's done,
you can run and log in to your image

    $ docker run -t -i pacapt /bin/bash
    # do something fun,
    # pacman -Q
    # exit

You have enjoyed your first `docker` journey.

## License

This work is published under a MIT license.
