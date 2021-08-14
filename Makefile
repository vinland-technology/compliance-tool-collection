
.PHONY: build

all: check-version

check-version:
	@dev/check-release.sh

build: 
	cd build/docker/compliance-tools && make build
	check_version

show:
	cd build/docker/compliance-tools && make docker-show

push:
	cd build/docker/compliance-tools && make push

clean:
	cd build/docker/compliance-tools && make docker-wipe
	docker system prune -f

manual:
	bin/compliance-tool --help > doc/compliance-tool.txt

size:
	cd build/docker/compliance-tools && make size
