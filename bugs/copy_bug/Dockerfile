# Link: https://github.com/docker/docker/issues/13045

FROM debian:wheezy
MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

RUN echo "" \
  && echo "You will not be able to build this image" \
  && echo "" \
  && echo "See more at https://github.com/docker/docker/issues/13045" \
  && echo ""

RUN mkdir /empty/
ADD /foobar/* /empty/
RUN rm -f /empty/null

CMD ["/bin/true"]
