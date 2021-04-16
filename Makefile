.PHONY: test docker push

IMAGE            ?= ghcr.io/rverma-nsl/kube-downscaler
VERSION          ?= $(shell git describe --tags --always --dirty)
TAG              ?= $(GITHUB_SHA)

default: docker

.PHONY: install
install:
	poetry install

.PHONY: lint
lint: install
	poetry run pre-commit run --all-files


test: lint install
	poetry run coverage run --source=kube_downscaler -m py.test -v
	poetry run coverage report

version:
	sed -i "s/version: v.*/version: v$(VERSION)/" deploy/*.yaml
	sed -i "s/kube-downscaler:.*/kube-downscaler:$(VERSION)/" deploy/*.yaml

docker:
	@echo ${{ secrets.GITHUB_TOKEN }} | docker login ghcr.io -u ${GITHUB_ACTOR} --password-stdin
	docker build --build-arg "VERSION=$(VERSION)" -t "$(IMAGE):$(TAG)" . --cache-from "$(IMAGE):latest"
	@echo 'Docker image $(IMAGE):$(TAG) can now be used.'

push: docker
	docker push "$(IMAGE):$(TAG)"
	docker tag "$(IMAGE):$(TAG)" "$(IMAGE):latest"
	docker push "$(IMAGE):latest"
