#!/bin/bash

#====================================================
# The following environment variables should be populated by the ansible scripts before the image is built.
#----------------------------------------------------
# DATABASE_PASSWORD
#====================================================


#====================================================
# The following are static set variables.
#----------------------------------------------------
BUILDSYSTEM=buildsystem.novatech-llc.com
SUPPORTSITE_SERVER=www.novatech-llc.com
SSH_OPTIONS="-i /root/.ssh/id_rsa_buildsystem -oStrictHostKeyChecking=no -oUser=root"
#----------------------------------------------------
BUILDSYSTEM_SQL_RESTORE_FILE="/restore/buildsystem_backup.sql"
BUILDSYSTEM_TFTP_RESTORE_FILE="/restore/tftp_files.tgz"
BUILDSYSTEM_TEST_CLIENT_RESTORE_FILE="/restore/test_client_files.tgz"
#----------------------------------------------------
BUILDSYSTEM_SQL_BACKUP_FILE="/backup/buildsystem_backup.sql"
BUILDSYSTEM_TFTP_BACKUP_FILE="/backup/tftp_files.tgz"
BUILDSYSTEM_TEST_CLIENT_BACKUP_FILE="/backup/test_client_files.tgz"
#----------------------------------------------------
SUPPORTSITE_SQL_RESTORE_FILE="/restore/supportsite_backup.sql"
#----------------------------------------------------
SUPPORTSITE_SQL_BACKUP_FILE="/backup/supportsite_backup.sql"
#====================================================

case ${1} in
    command_line)
        exec /bin/bash
    ;;
#===================================================================================================
    restore_buildsystem)
        if [ -e $BUILDSYSTEM_SQL_RESTORE_FILE ]; then
            echo "Restore BS MySQL"
            mysql --host=$BUILDSYSTEM --user=root --password=$DATABASE_PASSWORD < $BUILDSYSTEM_SQL_RESTORE_FILE
        fi
        if [ -e $BUILDSYSTEM_TFTP_RESTORE_FILE ]; then
            echo "Restore BS TFTP"
            scp $SSH_OPTIONS BUILDSYSTEM_TFTP_RESTORE_FILE $BUILDSYSTEM:/tmp/tftp_files.tgz
            ssh $SSH_OPTIONS $BUILDSYSTEM "tar -xz -f /tmp/tftp_files.tgz        --directory=/"
        fi
        if [ -e $BUILDSYSTEM_TEST_CLIENT_RESTORE_FILE ]; then
            echo "Restore BS Test Client"
            scp $SSH_OPTIONS $BUILDSYSTEM_TEST_CLIENT_RESTORE_FILE $BUILDSYSTEM:/tmp/test_client_files.tgz
            ssh $SSH_OPTIONS $BUILDSYSTEM "tar -xz -f /tmp/test_client_files.tgz --directory=/"
        fi
    ;;

    backup_buildsystem)
        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        # MySQL backup
        echo "Backup BS MySQL"
        mysqldump --host=$BUILDSYSTEM --user=root --password=$DATABASE_PASSWORD --all-databases --events --triggers --result-file=$BUILDSYSTEM_SQL_BACKUP_FILE
        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        # tftp file backup
        echo "Backup BS TFTP"
        ssh $SSH_OPTIONS $BUILDSYSTEM "tar -cz -f /tmp/tftp_files.tgz        --directory=/ /opt/tftp_files"
        scp $SSH_OPTIONS $BUILDSYSTEM:/tmp/tftp_files.tgz        $BUILDSYSTEM_TFTP_BACKUP_FILE
        ssh $SSH_OPTIONS $BUILDSYSTEM "rm -f /tmp/tftp_files.tgz"
        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        # static test client files stored on the server
        echo "Backup BS Test Client"
        ssh $SSH_OPTIONS $BUILDSYSTEM "tar -cz -f /tmp/test_client_files.tgz --directory=/ /opt/test_client_files"
        scp $SSH_OPTIONS $BUILDSYSTEM:/tmp/test_client_files.tgz $BUILDSYSTEM_TEST_CLIENT_BACKUP_FILE
        ssh $SSH_OPTIONS $BUILDSYSTEM "rm -f /tmp/test_client_files.tgz"
    ;;

    #-----------------------------------------------------------------------------------------------
    restore_supportsite)
        if [ -e $SUPPORTSITE_SQL_RESTORE_FILE ]; then
            echo "Restore SS MySQL"
            scp $SSH_OPTIONS $SUPPORTSITE_SQL_RESTORE_FILE supportsite_docker_container:/tmp/supportsite_restore.sql
            remote_restore_cmd="mysql --host=SupportSite_database_server --user=root --password=$DATABASE_PASSWORD < /tmp/supportsite_restore.sql"
            ssh $SSH_OPTIONS supportsite_docker_container $remote_restore_cmd
        fi
    ;;

    backup_supportsite)
        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        # MySQL backup
        echo "Backup SS MySQL"
        remote_dump_cmd="mysqldump --host=SupportSite_database_server --user=root --password=$DATABASE_PASSWORD --all-databases --events --triggers --result-file=/tmp/supportsite_backup.sql"
        ssh $SSH_OPTIONS supportsite_docker_container $remote_dump_cmd
        scp $SSH_OPTIONS supportsite_docker_container:/tmp/supportsite_backup.sql $SUPPORTSITE_SQL_BACKUP_FILE
        ssh $SSH_OPTIONS supportsite_docker_container "rm -f /tmp/supportsite_backup.sql"
        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        # Generating a 2 files to inventory items in the download directory
        echo "Backup SS Download File Info"
        ssh $SSH_OPTIONS supportsite_docker_container "find /opt/downloads/ -type f -exec md5sum {} \;" > /backup/supportsite_downloads_md5sum.txt
        ssh $SSH_OPTIONS supportsite_docker_container "ls -Fla --color=none /opt/downloads/" > /backup/supportsite_downloads_list.txt
    ;;
#===================================================================================================
    *)
        exec /bin/bash
    ;;

esac

