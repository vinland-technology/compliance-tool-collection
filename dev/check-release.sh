#!/bin/bash

# SPDX-FileCopyrightText: 2024 Henrik Sandklef <hesa@sandklef.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

DEV_DIR=$(dirname ${BASH_SOURCE[0]})
TOP_DIR=${DEV_DIR}/..
PATH=${TOP_DIR}/bin:${PATH}
COMPLIANCE_TOOL=${TOP_DIR}/bin/compliance-tool
TOOLS=" flict-to-dot reusew lookup-license dependencies.sh flict flame license-detector reuse scancode  spdx-validator"  

error()
{
    echo "$*" 1>&2
}

compare_mounts()
{
    DOCKER_MOUNT_TMP_DIR=$(grep "MOUNT_TMP_DIR=" build/docker/compliance-tools/Dockerfile | cut -d = -f 2 )
    DOCKER_MOUNT_DIR=$(grep "MOUNT_DIR=" build/docker/compliance-tools/Dockerfile | cut -d = -f 2  )

    CT_MOUNT_TMP_DIR=$(grep "MOUNT_TMP_DIR=" bin/compliance-tool | cut -d = -f 2)
    CT_MOUNT_DIR=$(grep "MOUNT_DIR=" bin/compliance-tool | cut -d = -f 2 | sed 's,^/,,g')

    printf "%-35s" "* Compare mount dir: "
    if [ "$DOCKER_MOUNT_DIR" != "$CT_MOUNT_DIR" ]
    then
        echo "ERROR. Mount dir differs"
        echo "   Docker mount point:            \"$DOCKER_MOUNT_DIR\""
        echo "   Compliance Tool mount point:   \"$CT_MOUNT_DIR\""
        exit 2
    fi
    echo "OK  ($DOCKER_MOUNT_DIR)"


    printf "%-35s" "* Compare tmp mount dir: "
    if [ "$DOCKER_MOUNT_TMP_DIR" != "$CT_MOUNT_TMP_DIR" ]
    then
        echo "ERROR. Mount dirs differs"
        echo "   Docker mount point:            \"$DOCKER_MOUNT_TMP_DIR\""
        echo "   Compliance Tool mount point:   \"$CT_MOUNT_TMP_DIR\""
        exit 2
    fi
    echo "OK  ($DOCKER_MOUNT_TMP_DIR)"

}

compare_image_name()
{
    CONTAINER_NAME=$(grep "CONTAINER_NAME=" build/docker/compliance-tools/Makefile | cut -d = -f 2)
    IMAGE_FIRST_NAME=$(grep "IMAGE_NAME="     build/docker/compliance-tools/Makefile | cut -d = -f 2 | cut -d / -f 1)
    MAKEFILE_NAME=${IMAGE_FIRST_NAME}/${CONTAINER_NAME}

    SCRIPT_NAME=$(grep "DOCKER_IMAGE=" bin/compliance-tool | cut -d = -f 2)

    printf "%-35s" "* Compare image name: "
    if [ ${MAKEFILE_NAME} != ${SCRIPT_NAME} ]
    then
        error "ERROR. Names differ:"
        error " * Makefile: ${MAKEFILE_NAME}"
        error " * script:   ${SCRIPT_NAME} ]"
        exit 1
    fi
    echo "OK  (${MAKEFILE_NAME})"
    
}

which_command()
{
    CMD="$1"
    set -o pipefail
    WHERE="$(${COMPLIANCE_TOOL} which ${CMD} 2>&1 | sed 's,[\n\r]*,,g')"
    RET=$?
    printf "%-35s" "* check $CMD: "
    if [ $RET -ne 0 ]
    then
        echo FAILED
        exit 1
    fi
    echo "OK $WHERE -- $RET"
#    echo "OK ($WHERE)"
#    echo "OK ($(echo $WHERE))"
}


exec_command()
{
    EXP=$1
    shift
    CMD="$*"
    RES=$(${COMPLIANCE_TOOL} ${CMD} 2>&1)
    RET=$?
    printf "%-35s" "* check $CMD: "
    if [ "$EXP" != "" ]
    then
        if [ "$EXP" = "$RES" ]
        then
            :
        else
            echo "Output mismatch for $CMD"
            echo "Expected: \"$EXP\""
            echo "Actual:   \"$RES\""
        fi
    fi
    if [ $RET -ne 0 ]
    then
        echo FAILED
        exit 1
    fi
    echo "OK"
}

version_command()
{
    PROG="$1"
    ARG="$2"
    VERSION=$(${COMPLIANCE_TOOL} ${PROG} ${ARG} 2>/dev/null)
    printf "* %-35s: %s\n" "$PROG" "$VERSION"
}

verify_tools_presence()
{
    for tool in $(echo $TOOLS | tr ' ' '\n' | sort )
    do
        which_command $tool
    done
}

#
# MAIN
#

echo "Verifying meta information"

compare_mounts
compare_image_name

echo "Veryfing all tools are present"
verify_tools_presence

echo "Verify tools work, phase I"
exec_command "" dependencies.sh --version
exec_command "" flict --version
exec_command "" flict-to-dot --version
exec_command "" reuse --version
exec_command "" reusew -h
exec_command "" scancode --version
exec_command "" scarfer --version
exec_command "" scarfer spdx-lookup -h
exec_command "" spdx-validator -h

echo "Verify tools work, phase II"
exec_command "MIT" lookup-license "mit"
exec_command "MIT" flame license "mit"
exec_command "Yes" flict -of text verify -il MIT -ol MIT
exec_command "MIT" flict -of text simplify "MIT AND MIT" 
exec_command "BSD-3-Clause AND GPL-2.0-or-later" flame -ndu -of text license "BSD3 and GPLv2+" 
exec_command "" o2h


echo
echo
echo "Yes :)"
echo
exit 0
