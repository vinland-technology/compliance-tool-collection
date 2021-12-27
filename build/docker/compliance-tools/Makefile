# FOSS Compliance Utils
#
# SPDX-FileCopyrightText: 2021 Henrik Sandklef
#
# SPDX-License-Identifier: GPL-3.0-or-later

CONTAINER_NAME=compliance-tools
IMAGE_NAME=sandklef/${CONTAINER_NAME}

MOUNT_DIR=/compliance-tools
TAG=0.5.5

check:
	@echo "IMAGE_NAME:     $(IMAGE_NAME)"
	@echo "CONTAINER_NAME: $(CONTAINER_NAME)"
	@echo "TAG:            $(TAG)"

run:
	docker run -it --rm -name $(CONTAINER_NAME) $(IMAGE_NAME):$(TAG) uname -a

version:
#	@echo -n "ORT version:      " && docker run -it --rm  --name $(CONTAINER_NAME) $(IMAGE_NAME):$(TAG) ort --version | grep  "version" | cut -d "," -f 2 | cut -d " " -f 3 | cut -d "." -f 1
	@echo -n "Scancode version: " && docker run -it --rm  --name $(CONTAINER_NAME) $(IMAGE_NAME):$(TAG) scancode --version | cut -d " " -f 3 
	@echo -n "flict version:    " && docker run -it --rm  --name $(CONTAINER_NAME) $(IMAGE_NAME):$(TAG) flict --version

build:
	docker build `pwd` -t $(IMAGE_NAME):$(TAG)

nc-build:
	docker build --no-cache `pwd` -t $(IMAGE_NAME):$(TAG)

push:
	docker push $(IMAGE_NAME):$(TAG)

docker-wipe-c:
	for c in `docker container ps -a |  grep compliance | awk '{print $$1}' | grep -v CONTA `; do docker container rm -f $$c; done

docker-wipe-i:
	for i in `docker image ls -a | grep compliance | awk ' {print $$3} ' | grep -v IMA `; do docker image rm -f $$i ; done

docker-wipe: docker-wipe-c docker-wipe-i

docker-show:
	@echo 
	@docker image ls -a
	@echo 
	@docker container ls -a
	@echo 
	@docker container ps -a

meta:
	grep "^[a-z\-]*:" Makefile 

size:
	@echo "Containers "
	@echo "===================================="
	docker ps -as
	@echo "Images"
	@echo "===================================="
	docker images

