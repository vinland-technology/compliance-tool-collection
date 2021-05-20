FROM python:3.6

# FOSS Compliance Utils / compliance-tool
#
# SPDX-FileCopyrightText: 2021 Henrik Sandklef
#
# SPDX-License-Identifier: GPL-3.0-or-later


ENV SCANCODE_VERSION=21.3.31
ENV LICENSE_DETECTOR_VERSION=v4.2.0
ENV MOUNT_DIR=compliance-tools



#######################################################
#
# update main system
#
#######################################################
RUN apt-get update && apt-get install -y bzip2 xz-utils zlib1g libxml2-dev libxslt1-dev p7zip-full




#######################################################
#
# Flict
#
#######################################################
RUN pip3 install license-expression spdx-license-list
RUN git clone https://github.com/vinland-technology/flict.git





#######################################################
#
# License Detector
#
#######################################################
RUN apt-get install -y golang
ADD "https://github.com/go-enry/go-license-detector/releases/download/${LICENSE_DETECTOR_VERSION}/license-detector-${LICENSE_DETECTOR_VERSION}-linux-amd64.tar.gz" license-detector-${LICENSE_DETECTOR_VERSION}-linux-amd64.tar.gz
RUN gunzip  license-detector-${LICENSE_DETECTOR_VERSION}-linux-amd64.tar.gz
RUN tar xvf license-detector-${LICENSE_DETECTOR_VERSION}-linux-amd64.tar
RUN chmod a+x license-detector





#######################################################
#
# REUSE
#
#######################################################
RUN pip3 install reuse                                         





#######################################################
#
# Compliance Utils
#
#######################################################
RUN git clone https://github.com/vinland-technology/compliance-utils.git





#######################################################
#
# Ninka
#
#######################################################
RUN apt-get install -y ninka ninka-backend-excel ninka-backend-sqlite





#######################################################
#
# Scancode
#
#######################################################
ADD "https://github.com/nexB/scancode-toolkit/releases/download/v${SCANCODE_VERSION}/scancode-toolkit-${SCANCODE_VERSION}_py36-linux.tar.xz" scancode-toolkit.tar.xz
RUN \
    xz -d scancode-toolkit.tar.xz && \
    tar xvf scancode-toolkit.tar
RUN cd scancode-toolkit-${SCANCODE_VERSION} && ./configure




#######################################################
#
# ORT / Open Source Review Toolkit
#
#######################################################
RUN apt-get install -y openjdk-11-jdk
RUN git clone https://github.com/oss-review-toolkit/ort.git
RUN cd ort && ./gradlew installDist

RUN mkdir ${MOUNT_DIR}
WORKDIR   ${MOUNT_DIR}

ENV PATH=$HOME/scancode-toolkit-${SCANCODE_VERSION}:$HOME/compliance-utils/bin:$HOME/flict:$HOME/ort/cli/build/install/ort/bin/:/:$PATH

