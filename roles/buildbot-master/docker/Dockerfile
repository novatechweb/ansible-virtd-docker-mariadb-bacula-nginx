ARG BUILDBOT_VERSION=v2.4.0
FROM  buildbot/buildbot-master:${BUILDBOT_VERSION}
LABEL maintainer="Andrew Cooper <andrew.cooper@novatechweb.com>"

ARG BUILDBOT_TIMEZONE="Etc/UTC"

COPY requirements.txt /usr/src/buildbot/requirements.txt

RUN cp /usr/share/zoneinfo/${BUILDBOT_TIMEZONE} /etc/localtime \
&&  echo "${BUILDBOT_TIMEZONE}" > /etc/timezone \
&&  pip3 install -r /usr/src/buildbot/requirements.txt

# Create buildbot user
ARG BUILDBOT_UID=1000
ARG BUILDBOT_WORKDIR=/var/lib/buildbot
WORKDIR "${BUILDBOT_WORKDIR}"
RUN adduser -h "/home/buildbot" -s "/bin/sh" -D -u ${BUILDBOT_UID} buildbot \
&&  chown -v -R buildbot:buildbot "${BUILDBOT_WORKDIR}" \
&&  mkdir -p -m 0700 "/home/buildbot/.ssh" \
&&  chown -v -R buildbot:buildbot "/home/buildbot" \
&&  su buildbot -c "\
    git config --global user.name Buildbot;\
    git config --global user.email buildbot@novatechweb.com"
USER buildbot

ENTRYPOINT [ "dumb-init" ]
CMD ["/usr/src/buildbot/docker/start_buildbot.sh"]
