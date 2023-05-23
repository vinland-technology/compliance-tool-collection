#!/bin/bash

DEV_DIR=$(dirname ${BASH_SOURCE[0]})
TOP_DIR=${DEV_DIR}/..
PATH=${TOP_DIR}/bin:${PATH}
COMPLIANCE_TOOL=${TOP_DIR}/bin/compliance-tool
TOOLS=" flict-to-dot yoga yoda reusew lookup-license dependencies.sh nfhc flict license-detector ninka reuse scancode scancode-manifestor spdx-validator"  # createnotices.py 

# about
error()
{
    echo "$*" 1>&2
}

compare_version()
{
    MAKEFILE_VERSION=$(grep "TAG=" build/docker/compliance-tools/Makefile | cut -d = -f 2)
    SCRIPT_VERSION=$(grep "DOCKER_TAG=" bin/compliance-tool | cut -d = -f 2)
    printf "%-35s" "* Compare version: "
    if [ ${MAKEFILE_VERSION} != ${SCRIPT_VERSION} ]
    then
        error "ERROR. Versions differ:"
        error " * build/docker/compliance-tools/Makefile: ${MAKEFILE_VERSION} "
        error " * bin/compliance-tool:                    ${SCRIPT_VERSION}   "
        exit 1
    fi
    echo "OK  (${MAKEFILE_VERSION})"
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
    CMD="$*"
    ${COMPLIANCE_TOOL} ${CMD} >/dev/null 2>&1
    RET=$?
    printf "%-35s" "* check $CMD: "
    if [ $RET -ne 0 ]
    then
        echo FAILED
        exit 1
    fi
    echo "OK"
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

compare_version
compare_mounts
compare_image_name

echo "Veryfing all tools are present"
#verify_tools_presence

echo "Verify tools work, phase I"
#exec_command createnotices.py -h
#exec_command deltacode --version
#exec_command license-detector 
#exec_command lookup-license
#exec_command ninka 
#exec_command about --version
#exec_command deltacode --version
exec_command dependencies.sh --version
exec_command flict --version
exec_command flict-to-dot --version
exec_command reuse --version
exec_command reusew -h
exec_command scancode --version
exec_command scancode-manifestor -h
exec_command scarfer --version
exec_command scarfer spdx-lookup -h
exec_command spdx-validator -h
exec_command nfhc --help
exec_command yoda --version
exec_command yoga --version


echo "Verify tools work, phase II"
echo -n "lookup-license: "
set -o pipefail
echo "bla bla" | ${COMPLIANCE_TOOL} lookup-license 2>/dev/null >/dev/null
RET=$?
printf "%-35s" "* check $CMD: "
if [ $RET -ne 0 ]
then
    echo FAILED
    exit 1
fi
echo OK
exec_command flict verify -il MIT -ol MIT
exec_command flict simplify "MIT AND MIT" 


echo
echo
echo "Yes :)"
echo
exit 0
