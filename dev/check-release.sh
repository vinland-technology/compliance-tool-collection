#!/bin/bash


error()
{
    echo "$*" 1>&2
}

compare_version()
{
    MAKEFILE_VERSION=$(grep "TAG=" build/docker/compliance-tools/Makefile | cut -d = -f 2)
    SCRIPT_VERSION=$(grep "DOCKER_TAG=" bin/compliance-tool | cut -d = -f 2)
    printf "%-30s" "* Compare version: "
    if [ ${MAKEFILE_VERSION} != ${SCRIPT_VERSION} ]
    then
        error "ERROR. Versions differ:"
        error " * Makefile: ${MAKEFILE_VERSION}"
        error " * script:   ${SCRIPT_VERSION} ]"
        exit 1
    fi
    echo "OK  (${MAKEFILE_VERSION})"
}

compare_image_name()
{
    CONTAINER_NAME=$(grep "CONTAINER_NAME=" build/docker/compliance-tools/Makefile | cut -d = -f 2)
    IMAGE_FIRST_NAME=$(grep "IMAGE_NAME="     build/docker/compliance-tools/Makefile | cut -d = -f 2 | cut -d / -f 1)
    MAKEFILE_NAME=${IMAGE_FIRST_NAME}/${CONTAINER_NAME}

    SCRIPT_NAME=$(grep "DOCKER_IMAGE=" bin/compliance-tool | cut -d = -f 2)

    printf "%-30s" "* Compare image name: "
    if [ ${MAKEFILE_NAME} != ${SCRIPT_NAME} ]
    then
        error "ERROR. Names differ:"
        error " * Makefile: ${MAKEFILE_NAME}"
        error " * script:   ${SCRIPT_NAME} ]"
        exit 1
    fi
    echo "OK  (${MAKEFILE_NAME})"
    
}



#
# MAIN
#

echo "Verifying meta information"

compare_version

compare_image_name
