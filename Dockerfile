FROM spritsail/alpine:3.11

ARG TAUTULLI_VER=2.1.44
ARG TIMEZONE=Etc/UTC

LABEL maintainer="Spritsail <tautulli@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="Tautulli" \
      org.label-schema.url="https://tautulli.com/" \
      org.label-schema.description="A Plex monitoring and statistics tool" \
      org.label-schema.version=${TAUTULLI_VER} \
      io.spritsail.version.tautulli=${TAUTULLI_VER}

ENV SUID=905 SGID=900

WORKDIR /tautulli

RUN apk --no-cache add python2 py-setuptools tzdata \
 && wget -O- https://github.com/Tautulli/Tautulli/tarball/v${TAUTULLI_VER} \
        | tar xz --strip-components=1 \
# https://github.com/Tautulli/Tautulli/blob/master/plexpy/versioncheck.py#L120
 && printf "v$TAUTULLI_VER" > version.txt \
# Fix pytz default timezone to UTC
 && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
 && apk --no-cache del tzdata

VOLUME ["/config", "/media"]
EXPOSE 8081

HEALTHCHECK --start-period=10s --timeout=5s \
    CMD wget -qO /dev/null "http://localhost:8181/status"

CMD ["python2", "/tautulli/Tautulli.py", "--datadir", "/config", "--nolaunch", "--verbose"]
