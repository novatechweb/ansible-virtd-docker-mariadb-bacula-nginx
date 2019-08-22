FROM alpine:3.8

WORKDIR /easyrsa
VOLUME /easyrsa

RUN apk --no-cache add \
        openssh-server-pam \
        openssh-client \
        libcrypto1.0 \
        libssl1.0 \
        openssl \
&&  rm /etc/motd \
&&  echo "UsePAM yes" >> /etc/ssh/sshd_config \
&&  ssh-keygen -A \
&&  /usr/sbin/sshd -t

COPY entrypoint.sh /entrypoint.sh

ARG EASYRSA_UID=1000
RUN adduser -h "/home/easyrsa" -s "/bin/ash" -D -u ${EASYRSA_UID} easyrsa \
&&  mkdir -p -m 0700 "/home/easyrsa/.ssh" \
&&  chown -v -R easyrsa:easyrsa "/home/easyrsa" \
&&  mkdir -p -m 0750 "/easyrsa" \
&&  chown -v -R easyrsa:easyrsa "/easyrsa" \
&&  echo "cd /easyrsa" > "/home/easyrsa/.profile" \
&&  chmod 0755 "/entrypoint.sh"

CMD ["/entrypoint.sh"]
