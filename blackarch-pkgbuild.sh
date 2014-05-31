#!/bin/sh
################################################################################
#                                                                              #
# blackarch-pkgbuild - PKGBUILD Generator                                      #
#                                                                              #
# FILE                                                                         #
# blackarch-pkgbuild.sh                                                        #
#                                                                              #
# DATE                                                                         #
# 2014-05-27                                                                   #
#                                                                              #
# DESCRIPTION                                                                  #
# <LDESCR>                                                                     #
#                                                                              #
# AUTHOR                                                                       #
# nrz@nullsecurity.net                                                         #
# noptrix@nullsecurity.net                                                     #
# eitelmanevan@gmail.com (paraxor)                                             #
#                                                                              #
################################################################################

PWD_PKGBUILD="path_to_blackarch-pkgbuild/blackarch-pkgbuild"

# blackarch-pkgbuild version
VERSION="blackarch-pkgbuild v0.1"

# true / false
FALSE="0"
TRUE="1"

# return codes
SUCCESS="1337"
FAILURE="31337"

# verbose mode - default: quiet
VERBOSE="/dev/null"

# colors
WHITE="$(tput bold ; tput setaf 7)"
GREEN="$(tput setaf 2)"
RED="$(tput bold; tput setaf 1)"
YELLOW="$(tput bold ; tput setaf 3)"
NC="$(tput sgr0)" # No Color


wprintf() {
    fmt=$1
    shift
    printf "%s${fmt}%s\n" "${WHITE}" "$@" "${NC}"

    return "${SUCCESS}"
}

# print warning
warn()
{
    fmt=${1}
    shift
    printf "%s[!] WARNING: ${fmt}%s\n" "${RED}" "${@}" "${NC}"

    return "${SUCCESS}"
}

# print error and exit
err()
{
    fmt=${1}
    shift
    printf "%s[-] ERROR: ${fmt}%s\n" "${RED}" "${@}" "${NC}"

    return "${FAILURE}"
}

# print error and exit
cri()
{
    fmt=${1}
    shift
    printf "%s[-] CRITICAL: ${fmt}%s\n" "${RED}" "${@}" "${NC}"

    exit "${FAILURE}"
}


# leet banner, very important
banner()
{
    echo "--==[ blackarch-pkgbuild by BlackArch ]==--"

    return "${SUCCESS}"
}

check()
{
    ! [ -d "${PWD_PKGBUILD}" ] && cri "Fix PKG_NAME path at source" &&
        exit "${FAILURE}"
}

usage()
{
printf "%s" "${WHITE}"

cat <<EOF
Usage: ${0##*/} <arg>
OPTIONS:
    -p <name>: package name

EOF
    printf "%s" "${NC}"

    exit "${SUCCESS}"
}


get_opts()
{
    while getopts p: flags
    do
        case "${flags}" in
            p)
                PKG_NAME=${OPTARG}
                ;;
            *)
                usage
                exit
                ;;
        esac
    done

    return "${SUCCESS}"
}


run()
{

    mkdir -p "${PKG_NAME}"

    find "${PWD_PKGBUILD}/templates" \
        -maxdepth 1 -mindepth 1 -type d > "${PWD_PKGBUILD}/tmp.lst"

    count="1"
    local IFS='|'
    ( while read -r lang; do
        wprintf "    [%s] %s" "${count}" "${lang##*/}"
        ((count++))
    done < "${PWD_PKGBUILD}/tmp.lst" )

    printf "%s" "${WHITE}"

    printf "Choose lang: "; read a

    LANG=$(sed -n "${a}p" "${PWD_PKGBUILD}/tmp.lst")
    cp "${LANG}/PKGBUILD" "${PKG_NAME}/"

    rm -rf ${PWD_PKGBUILD}/tmp.lst

    printf "%s" "${NC}"

}

# controller and program flow
main()
{
    banner
    check
    get_opts ${*}
    [ -n "${PKG_NAME}" ] && run && exit 0
    [ -z "${PKG_NAME}" ] && usage

    return "${SUCCESS}"
}


# program start
main ${*}

# EOF
