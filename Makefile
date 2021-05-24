
.PHONY: build

all: check-version

check-version:
	@dev/check-release.sh

build: check-version 
	cd build/docker/compliance-tools && make build

show:
	cd build/docker/compliance-tools && make docker-show

clean:
	cd build/docker/compliance-tools && make docker-wipe

manual:
	bin/compliance-tool --help > doc/compliance-tool.txt

