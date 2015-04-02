
## Docker Image for AfterShotPro-1.2.0.7

### Instructions

1. Build the image

      $ git checkout https://github.com/icy/docker.git icy-docker
      $ cd icy-docker/aftershot/
      $ docker build --rm=true -t aftershot .

2. Run the docker

      $ mkdir -pv /home/aftershot/{local,global,catalogs}

      $ docker run \
        -d -P \
          -e _UID=314 \
          -e _GID=314 \
          -v /home/aftershot/local/:/home/aftershot/.AfterShotPro/ \
          -v /home/aftershot/global/:/home/aftershot/.config/Corel/ \
          -v /home/aftershot/catalogs/:/home/aftershot/catalogs/ \
          -v /home/pictures/:/home/pictures/ \
          ... \
        aftershot:latest

3. Get the `NAT`ed port number with

      $ docker ps
      f8d385... aftershot:latest   ...  0.0.0.0:49162->22/tcp  ...
      # 49162 is the port that you need

4. Execute AfterShotPro via `ssh`

      $ ssh -X aftershot@localhost -p PORT AfterShotPro
      # Enter the password 'aftershot'

### In-depth details

`AfterShotPro` requires different directories

1. A place to store global settings: user registration key,
    path to catalogs and/or cache directory, bla bla.
   The path is `$HOME/.config/Corel/`.
2. A place for local settings: list of plugins, cache tuning information,
   temporary folders, ...; the path is `$HOME/.AfterShotPro/` by default.
3. A place to store all catalogs' information. This depends on your settings.

That's why you need to mount host directories to a running `docker`
as in the above example.

And to make sure the `Docker`'s `AfterShotPro` program can read/write
to your local directory, you need to provide `_UID` and `_GID` variables;
they are your own `UID` and `GID`. In the examples, they are `314`s.
