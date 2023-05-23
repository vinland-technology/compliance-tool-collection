FROM python:3.11

# FOSS Compliance Utils / compliance-tool
#
# SPDX-FileCopyrightText: 2021 Henrik Sandklef
#
# SPDX-License-Identifier: GPL-3.0-or-later


ENV LICENSE_DETECTOR_VERSION=v4.2.0
ENV MOUNT_DIR=compliance-tools
ENV MOUNT_TMP_DIR=/tmp/compliance-tools



#######################################################
#
# update main system
#
#######################################################
RUN apt-get update && apt-get install -y bzip2 xz-utils zlib1g libxml2-dev libxslt1-dev p7zip-full jq




#######################################################
#
# Flict
#
#######################################################
RUN git clone https://github.com/vinland-technology/flict.git
RUN cd flict && pip3 install -r requirements.txt && pip3 install .


#######################################################
#
# License Detector
#
#######################################################
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
# Scancode Manifestor
#
#######################################################
RUN git clone https://github.com/vinland-technology/scancode-manifestor.git
RUN cd scancode-manifestor && pip3 install .


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
# get requirements, just in case
RUN pip3 install scancode-toolkit==31.2.6
RUN scancode --reindex-licenses


#######################################################
#
# Armijn's compliance-scripts
#
#######################################################
#RUN git clone https://github.com/armijnhemel/compliance-scripts.git
#RUN cd compliance-scripts && git submodule init && git submodule update && chmod a+x copyright-statements/createnotices.py



#######################################################
#
# Henrik's spdx-validator (hesa... yeah, that's me)
#
#######################################################
RUN git clone https://github.com/hesa/spdx-validator.git
RUN cd spdx-validator && pip install .


#######################################################
#
# Henrik's scarfer (hesa... yeah, that's me)
#
#######################################################
RUN git clone https://github.com/hesa/scarfer.git
RUN cd scarfer && pip install .



#######################################################
#
# ORT / Open Source Review Toolkit
#
#######################################################
#RUN apt-get install -y openjdk-11-jdk-headless
#RUN git clone https://github.com/oss-review-toolkit/ort.git
#RUN cd ort && ./gradlew installDist



#######################################################
#
# Compliance Utils
#
#######################################################
RUN pip3 install spdx-lookup spdx-license-list spdx-tools
RUN git clone https://github.com/vinland-technology/compliance-utils.git

#######################################################
#
# Naive FOSS Health checker
#
#######################################################
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN git clone https://github.com/hesa/foss-health.git
RUN cd foss-health && python3.9 -m pip install -r requirements.txt && python3.9 -m pip install --use-pep517 . 

RUN pip3 install spdx


RUN mkdir ${MOUNT_TMP_DIR}
RUN mkdir ${MOUNT_DIR}
WORKDIR   ${MOUNT_DIR}

ENV PATH=$HOME/compliance-utils/bin:$HOME/scancode-manifestor:/usr/local/bin:/:/compliance-scripts/copyright-statements:$PATH
