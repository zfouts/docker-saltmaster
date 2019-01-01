### Dockerfile

FROM ubuntu:18.04
LABEL maintainer "zach@linux.com"
RUN \
  apt-get update && apt-get install --yes --no-install-recommends wget \
  && mkdir -p /srv/salt \
  && wget -O bootstrap-salt.sh https://bootstrap.saltstack.com --no-check-certificate \
  && sh bootstrap-salt.sh -M

RUN \
  apt-get autoclean --yes \
  && rm -rf /var/lib/apt/lists/*

COPY entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

ENTRYPOINT ["/entry-point.sh"]

