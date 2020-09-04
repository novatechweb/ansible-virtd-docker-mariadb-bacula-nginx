#!/bin/bash
set -e

# Load apache shell variables
source /etc/apache2/envvars


MANTISBT_BASE_DIR=$(pwd)
: ${MANTIS_SRC:=/usr/src/mantisbt}

lock_mantisbt() {
    # set mantisbt to readonly if not already
    cp ${MANTISBT_BASE_DIR}/mantis_offline.php.sample ${MANTISBT_BASE_DIR}/mantis_offline.php
    echo >&2 "MantisBT locked to read-only mode"
    # wait for any transactions to compleate
    sleep 5
}

unlock_mantisbt() {
    # set MantisBT to read/write
    rm -f ${MANTISBT_BASE_DIR}/mantis_offline.php
    echo >&2 "MantisBT unlocked to read-write mode"
}

case ${1} in
    mantisbt)
        # verify permissions
        chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} .
        # Apache gets grumpy about PID files pre-existing
        rm -f "${APACHE_PID_FILE}"
        # Run unattended upgrade script.
        if [ -f ${MANTISBT_BASE_DIR}/admin/upgrade_unattended.php ]; then
            cd ${MANTISBT_BASE_DIR}
            php ${MANTISBT_BASE_DIR}/admin/upgrade_unattended.php
            rm -rf ${MANTISBT_BASE_DIR}/admin/
        fi
        # Start apache
        exec apache2-foreground
        ;;

    lock)
        if [[ ! -w ${MANTISBT_BASE_DIR}/mantis_offline.php.sample ]]; then
            echo >&2 "Sample locking file not found: ${MANTISBT_BASE_DIR}/mantis_offline.php.sample"
            exit 1
        fi
        lock_mantisbt
        ;;

    unlock)
        if [[ ! -w ${MANTISBT_BASE_DIR}/mantis_offline.php.sample ]]; then
            echo >&2 "Sample locking file not found: ${MANTISBT_BASE_DIR}/mantis_offline.php.sample"
            exit 1
        fi
        unlock_mantisbt
        ;;

    remove_admin)
        # remove the admin directory
        rm -rf ${MANTISBT_BASE_DIR}/admin
        ;;

    *)
        # run some other command in the docker container
        exec "$@"
        ;;
esac
