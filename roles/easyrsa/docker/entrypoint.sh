#!/bin/sh

chown -R easyrsa:easyrsa "/easyrsa"
chown -R easyrsa:easyrsa "/home/easyrsa"
chmod -R 0700 "/home/easyrsa/.ssh"

exec /usr/sbin/sshd -D -e
