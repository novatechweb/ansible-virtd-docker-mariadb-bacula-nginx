# ansible-virtd-docker-mariadb-bacula-nginx


# to test the before_backup.sh script
sudo -HEu bacula /usr/libexec/bacula/before_backup ; echo $?

# to test the after_backup.sh script
sudo -HEu bacula /usr/libexec/bacula/after_backup ; echo $?

# to check for selinux policy changes
audit2allow -abm baculavirt

