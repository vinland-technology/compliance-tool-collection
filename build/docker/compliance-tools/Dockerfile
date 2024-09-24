FROM python:3.11

# FOSS compliance-tool
#
# SPDX-FileCopyrightText: 2024 Henrik Sandklef
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

ENV LICENSE_DETECTOR_VERSION=v4.2.0
ENV MOUNT_DIR=compliance-tools
ENV MOUNT_TMP_DIR=/tmp/compliance-tools


#######################################################
#
# Update main system (apt)
#
#######################################################
RUN apt-get update && apt-get install -y bzip2 xz-utils zlib1g libxml2-dev libxslt1-dev p7zip-full jq




#######################################################
#
# Misc tools (pypi)
#
#######################################################
RUN pip3 install spdx spdx-lookup spdx-license-list spdx-tools flict scarfer spdx-validator foss-flame scancode-toolkit reuse lookup-license elmat


#######################################################
#
# License Detector (git)
#
#######################################################
ADD "https://github.com/go-enry/go-license-detector/releases/download/${LICENSE_DETECTOR_VERSION}/license-detector-${LICENSE_DETECTOR_VERSION}-linux-amd64.tar.gz" license-detector-${LICENSE_DETECTOR_VERSION}-linux-amd64.tar.gz
RUN gunzip  license-detector-${LICENSE_DETECTOR_VERSION}-linux-amd64.tar.gz
RUN tar xvf license-detector-${LICENSE_DETECTOR_VERSION}-linux-amd64.tar
RUN chmod a+x license-detector


#######################################################
#
# Compliance Utils (git)
#
#######################################################
RUN git clone https://github.com/vinland-technology/compliance-utils.git



RUN mkdir ${MOUNT_TMP_DIR}
RUN mkdir ${MOUNT_DIR}
WORKDIR   ${MOUNT_DIR}

ENV PATH=/usr/local/bin:/:/compliance-scripts/copyright-statements:$HOME/compliance-utils/bin:$PATH
