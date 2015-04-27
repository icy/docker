FROM debian:stable
MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

RUN mkdir /empty/

RUN echo first > /empty/first.txt
VOLUME /empty/

RUN echo second > /empty/second.txt
VOLUME /empty/

RUN echo third > /empty/third.txt
VOLUME /empty/

RUN echo fourth > /empty/fourth.txt

COPY add_first.txt /empty/

CMD ["/usr/bin/find", "/empty/"]
