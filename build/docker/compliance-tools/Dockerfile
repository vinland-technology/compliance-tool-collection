FROM python:3.8

# FOSS Compliance Utils / compliance-tool
#
# SPDX-FileCopyrightText: 2021 Henrik Sandklef
#
# SPDX-License-Identifier: GPL-3.0-or-later


ENV LICENSE_DETECTOR_VERSION=v4.2.0
ENV SCANCODE_VERSION=v31.2.3
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
RUN apt-get install -y python3
RUN apt-get install -y python3-pip 
RUN git clone https://github.com/vinland-technology/flict.git
RUN cd flict && python3.9 -m pip install -r requirements.txt && python3.9 -m pip install .



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
# Compliance Utils
#
#######################################################
RUN git clone https://github.com/vinland-technology/compliance-utils.git


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
# ADD https://github.com/nexB/scancode-toolkit/releases/download/${SCANCODE_VERSION}/scancode-toolkit-${SCANCODE_VERSION}_py3.8-linux.tar.gz scancode-toolkit-${SCANCODE_VERSION}_py3.8-linux.tar.gz
# RUN gunzip scancode-toolkit-${SCANCODE_VERSION}_py3.8-linux.tar.gz 
# RUN tar xvf scancode-toolkit-${SCANCODE_VERSION}_py3.8-linux.tar

#ADD https://github.com/nexB/scancode-toolkit/releases/download/${SCANCODE_VERSION}/scancode-toolkit-${SCANCODE_VERSION}_sources.tar.gz scancode-toolkit-${SCANCODE_VERSION}_sources.tar.gz
#RUN gunzip  scancode-toolkit-${SCANCODE_VERSION}_sources.tar.gz
#RUN tar xvf scancode-toolkit-${SCANCODE_VERSION}_sources.tar
#RUN
RUN pip install scancode-toolkit


#######################################################
#
# Aboutcode (hesa's fork)
#
#######################################################
# TODO: get from nexb
RUN git clone https://github.com/hesa/aboutcode-toolkit.git
RUN cd aboutcode-toolkit && git pull --all && git checkout hesa_devel
RUN cd aboutcode-toolkit && ./configure

#######################################################
#
# Deltacode
#
#######################################################
RUN git clone https://github.com/nexB/deltacode.git
RUN cd deltacode && ./configure


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

RUN mkdir ${MOUNT_TMP_DIR}
RUN mkdir ${MOUNT_DIR}
WORKDIR   ${MOUNT_DIR}

ENV PATH=$HOME/scancode-toolkit-${SCANCODE_VERSION}:$HOME/aboutcode-toolkit:$HOME/deltacode:$HOME/compliance-utils/bin:$HOME/scancode-manifestor:/usr/local/bin:/:/compliance-scripts/copyright-statements:$PATH

