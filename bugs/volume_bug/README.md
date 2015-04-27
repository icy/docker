## VOLUME and RUN

In a `Dockerfile`, a volume is created by `VOLUME volume-name`.
After the `VOLUME` command, the `RUN` instruction can't add any file
to the volume's directory

For example, if you have a chain

    RUN echo first > /empty/first.txt
    VOLUME /empty/

    RUN echo second > /empty/second.txt
    VOLUME /empty/

The final image only contain `/empty/first.txt`, while the second file
`/empty/second.txt` is discarded.

## VOLUME and COPY

However, the `COPY` (and `ADD`) instructions can add file after
`VOLUME` command

    # VOLUMe /empty/
    COPY add_first.txt /empty/

The final image will contain `add_first.txt` as expected.

## Reproduce the problem

Build the image and see the result

    $ docker build -t icy/volume_bug .
    $ docker run -ti --rm icy/volume_bug
    /empty/
    /empty/first.txt
    # no other files

## Note

This problem explains exactly the problem in `icy/chmod_bug`.
