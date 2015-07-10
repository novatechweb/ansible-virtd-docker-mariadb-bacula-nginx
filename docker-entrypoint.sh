#!/bin/bash
set -e

BACKUP_PATH=/tmp/import_export
CONFIG_PATH=/etc/ldap/slapd.d
DB_PATH=/var/lib/ldap
SLAPADD=/usr/sbin/slapadd
SLAPCAT=/usr/sbin/slapcat

# When not limiting the open file descritors limit, the memory consumption of
# slapd is absurdly high. See https://github.com/docker/docker/issues/8231
ulimit -n 8192

usage() {
    echo "Usage: ${0} <OPTION> [ARGUMENTS ...]" >&2
    echo "OPTIONS:" >&2
    echo "  openldap            Run slapd process" >&2
    echo "  init_data_volumes   Reset/Set OpenLDAP back to package default" >&2
    echo "  backup              Creates an LDIF file of the specified database" >&2
    echo "    ARGUMENTS: <dbnum> <ldif-file>" >&2
    echo "      dbnum           The database number. \"0\" specifies OpenLDAP config." >&2
    echo "      ldif-file       The LDIF filename to create in ${BACKUP_PATH}" >&2
    echo "  apply_ldif          apply a series of LDIF files to specified databases (default: OpenLDAP config)" >&2
    echo "    ARGUMENTS: <-n suffix | -b dbnum> <-l ldif-file>" >&2
    echo "      -n suffix       The specified suffix to determine which database to add subsequent LDIF files" >&2
    echo "      -b dbnum        The dbnum-th database listed in the configuration file to apply the subsequent LDIF files" >&2
    echo "      -l ldif-file    The specified LDIF file to import" >&2
    echo "  <Another Program>   Any other program on the system followed by it's arguments" >&2
    exit 1
}

case ${1} in
    openldap)
        exec slapd -d 32768 -u openldap -g openldap -h "ldap:/// ldapi:/// ldaps:///"
        ;;

    init_data_volumes)
        rm -rf ${CONFIG_PATH}/../* ${DB_PATH}/*
        mkdir -p ${CONFIG_PATH}
        cd /etc
        tar -xavf /etc/ldap.tar.gz ldap/schema/
        chown -R openldap.openldap ${DB_PATH} ${CONFIG_PATH}
        ;;

    apply_ldif)
        [[ ! -d ${BACKUP_PATH} ]] && exit 1
        suffix=''
        dbnum='0'
        while getopts ":b:n:l:" opt; do
            case ${opt} in
              b)
                suffix=${OPTARG}
                dbnum=''
                ;;

              n)
                suffix=''
                dbnum=${OPTARG}
                ;;

              l)
                ldif_file=${OPTARG}
                if [[ ! -e ${BACKUP_PATH}/${ldif_file} ]] ; then
                    echo "LDIF file not found: ${ldif_file}" >&2
                    continue
                fi
                if [[ -z "${dbnum}" ]]; then
                    nice ${SLAPADD} -F ${CONFIG_PATH} -b ${suffix} -l ${BACKUP_PATH}/${ldif_file}
                else
                    nice ${SLAPADD} -F ${CONFIG_PATH} -n ${dbnum} -l ${BACKUP_PATH}/${ldif_file}
                fi
                ;;

              \?)
                echo "Invalid option: -$OPTARG" >&2
                usage
                ;;
            esac
        done
        chown -R openldap.openldap ${DB_PATH} ${CONFIG_PATH}
        ;;

    backup)
        dbnum=${2}
        ldif_file=${3}
        nice ${SLAPCAT} -F ${CONFIG_PATH} -n ${dbnum} > ${BACKUP_PATH}/${ldif_file}
        chmod 640 ${BACKUP_PATH}/*.ldif
        ;;

    *)
        # run some other command in the docker container
        exec "$@"
        ;;

esac
