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
    echo >&2 "Usage: ${0} <OPTION> [ARGUMENTS ...]"
    echo >&2 "OPTIONS:"
    echo >&2 "  openldap            Run slapd process"
    echo >&2 "  init_data_volumes   Reset/Set OpenLDAP back to package default"
    echo >&2 "  backup              Creates LDIF files for all databases"
    echo >&2 "  apply_ldif          apply a series of LDIF files to specified databases (default: OpenLDAP config)"
    echo >&2 "    ARGUMENTS: <-n suffix | -b dbnum> <-l ldif-file>"
    echo >&2 "      -n suffix       The specified suffix to determine which database to add subsequent LDIF files"
    echo >&2 "      -b dbnum        The dbnum-th database listed in the configuration file to apply the subsequent LDIF files"
    echo >&2 "      -l ldif-file    The specified LDIF file to import"
    echo >&2 "  <Another Program>   Any other program on the system followed by it's arguments"
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
        while getopts ":b:n:l:" opt ${@:2}; do
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
                    echo >&2 "LDIF file not found: ${ldif_file}"
                    continue
                fi
                if [[ -z "${dbnum}" ]]; then
                    nice ${SLAPADD} -F ${CONFIG_PATH} -b ${suffix} -l ${BACKUP_PATH}/${ldif_file}
                else
                    nice ${SLAPADD} -F ${CONFIG_PATH} -n ${dbnum} -l ${BACKUP_PATH}/${ldif_file}
                fi
                ;;

              \?)
                echo >&2 "Invalid option: -$OPTARG"
                usage
                ;;
            esac
        done
        chown -R openldap.openldap ${DB_PATH} ${CONFIG_PATH}
        ;;

    backup)
        dbnum=0
        while nice ${SLAPCAT} -F ${CONFIG_PATH} -n ${dbnum} > ${BACKUP_PATH}/LDAP_database_$(printf '%04d' ${dbnum}).ldif
        do
            dbnum=$((dbnum + 1))
        done
        rm ${BACKUP_PATH}/LDAP_database_$(printf '%04d' ${dbnum}).ldif
        chmod 640 ${BACKUP_PATH}/*.ldif
        ;;

    *)
        # run some other command in the docker container
        exec "$@"
        ;;

esac
