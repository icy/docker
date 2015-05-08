## "COPY foo/* bar/" not work if no file in foo/

Link: https://github.com/docker/docker/issues/13045

## Example

````
Step 0 : COPY source/* /source/
INFO[0001] No source files were specified
````

If there isn't any file in `source/` directory, the build will fail.

Expected behavior: Continue if no file matches `source/*`.

This is very annoyed when `COPY` is provided as `ON BUILD` instruction.

Docker information:
  https://github.com/icy/docker/blob/master/bugs/volume_bug/docker.info.txt

## Reproduce

````
$ git clone https://github.com/icy/docker.git
$ cd bugs/copy_bug
$ docker build -t icy/copy_bug .

...

Step 4 : ADD /foobar/* /empty/
INFO[0014] No source files were specified
````
