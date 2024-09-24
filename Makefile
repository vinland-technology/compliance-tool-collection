# SPDX-FileCopyrightText: 2024 Henrik Sandklef <hesa@sandklef.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later

.PHONY: build

all: check_version clean reuse README.md

release: clean nc-build README.md

versions.txt:
	bin/compliance-tool --versions > versions.txt

README.md: versions.txt
	cat template/README.tmpl | perl  -p -e "s/__VERSIONS__/`cat versions.txt`/g" | sed -e "s,^[ ]*\*,\*,g" > README.md

check_version:
	@dev/check-release.sh

build:
	@echo Build
	cd build/docker/compliance-tools && make build
	@echo check version
	make check_version

nc-build:
	@echo Build
	cd build/docker/compliance-tools && make nc-build
	@echo check version
	make check_version

show:
	cd build/docker/compliance-tools && make docker-show

push:
	cd build/docker/compliance-tools && make push

docker-clean:
	cd build/docker/compliance-tools && make docker-wipe
	docker system prune -f

clean:
	find . -name "*~" | xargs rm -f
	rm -f versions.txt


manual:
	bin/compliance-tool --help > doc/compliance-tool.txt

size:
	cd build/docker/compliance-tools && make size

reuse:
	reuse --suppress-deprecation lint
