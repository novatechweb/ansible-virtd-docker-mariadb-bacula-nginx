FROM ubuntu:14.04.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
                    mysql-client=5.5* \
                    openssh-client=1:6* && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /root/.ssh/; chmod 700 /root/.ssh
COPY ./id_rsa_buildsystem /root/.ssh/id_rsa_buildsystem

COPY ./entrypoint.sh /
RUN chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["command_line"]
