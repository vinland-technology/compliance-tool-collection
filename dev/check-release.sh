#!/bin/bash


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
        error " * Makefile: ${MAKEFILE_VERSION}"
        error " * script:   ${SCRIPT_VERSION} ]"
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



#
# MAIN
#

echo "Verifying meta information"

compare_version

compare_mounts

compare_image_name
