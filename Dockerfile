FROM ubuntu:14.04.2

# The following volume is for the Test Station's database data.
VOLUME /var/lib/mysql

CMD ["/bin/true"]
