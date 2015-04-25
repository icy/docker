FROM icy/empty

MAINTAINER Anh K. Huynh "kyanh@theslinux.org"

# empty is a volume from `empty` container

ADD chmod.sh /empty/
RUN ln -s /empty/chmod.sh /empty/fail.sh
RUN chmod 755 -c /empty/chmod.sh

ADD chmod.sh /
RUN chmod 755 /chmod.sh

CMD ["/chmod.sh"]
