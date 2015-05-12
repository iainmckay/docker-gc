FROM ubuntu:14.04
MAINTAINER Iain Mckay <me@iainmckay.co.uk>

RUN apt-get update \
    && apt-get install -y python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc /usr/bin/docker-gc
RUN chmod +x /usr/bin/docker-gc

CMD ["/usr/bin/docker-gc"]
