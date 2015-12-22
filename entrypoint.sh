#!/bin/bash

#====================================================
# The following environment variables should be populated by the ansible scripts before the image is built.
#----------------------------------------------------
# DATABASE_PASSWORD
#----------------------------------------------------

#====================================================
# The following are static set variables.
#----------------------------------------------------
# BUILDSYSTEM=buildsystem.novatech-llc.com
# SUPPORTSITE_SERVER=www.novatech-llc.com
BUILDSYSTEM=172.16.64.105
SUPPORTSITE_SERVER=test.novatech-llc.com
SSH_OPTIONS="-i /root/.ssh/id_rsa_buildsystem -oStrictHostKeyChecking=no -oUser=root"
#----------------------------------------------------

if [ -d "/backup" ]; then
    IS_BACKUP=/bin/true
else
    IS_BACKUP=/bin/false
fi

if [ -e "/restore/buildsystem_backup.sql" ]; then
    IS_BS_RESTORE=/bin/true
else
    IS_BS_RESTORE=/bin/false
fi

if [ -e "/restore/supportsite_backup.sql" ]; then
    IS_SS_RESTORE=/bin/true
else
    IS_SS_RESTORE=/bin/false
fi

echo "IS_BACKUP:     $IS_BACKUP"
echo "IS_BS_RESTORE: $IS_BS_RESTORE"
echo "IS_SS_RESTORE: $IS_SS_RESTORE"

case ${1} in
    command_line)
        exec /bin/bash
    ;;
#===================================================================================================
    restore_buildsystem)
        mysql --host=$BUILDSYSTEM --user=root --password=$DATABASE_PASSWORD < /restore/buildsystem_backup.sql
        # SCP tar files
        scp $SSH_OPTIONS /restore/tftp_files.tgz        $BUILDSYSTEM:/tmp/tftp_files.tgz
        scp $SSH_OPTIONS /restore/test_client_files.tgz $BUILDSYSTEM:/tmp/test_client_files.tgz
        # Untar files
        ssh $SSH_OPTIONS $BUILDSYSTEM "tar -xz -f /tmp/tftp_files.tgz        --directory=/"
        ssh $SSH_OPTIONS $BUILDSYSTEM "tar -xz -f /tmp/test_client_files.tgz --directory=/"
    ;;

    backup_buildsystem)
        mysqldump --host=$BUILDSYSTEM --user=root --password=$DATABASE_PASSWORD --all-databases --events --triggers --result-file=/backup/buildsystem_backup.sql
        # TAR up files
        ssh $SSH_OPTIONS $BUILDSYSTEM "tar -cz -f /tmp/tftp_files.tgz        --directory=/ /opt/tftp_files"
        ssh $SSH_OPTIONS $BUILDSYSTEM "tar -cz -f /tmp/test_client_files.tgz --directory=/ /opt/test_client_files"
        # SCP files
        scp $SSH_OPTIONS $BUILDSYSTEM:/tmp/tftp_files.tgz        /backup/tftp_files.tgz
        scp $SSH_OPTIONS $BUILDSYSTEM:/tmp/test_client_files.tgz /backup/test_client_files.tgz
        # Remove files
        ssh $SSH_OPTIONS $BUILDSYSTEM "rm -f /tmp/tftp_files.tgz"
        ssh $SSH_OPTIONS $BUILDSYSTEM "rm -f /tmp/test_client_files.tgz"
    ;;
#===================================================================================================
    *)
        exec /bin/bash
    ;;

esac

