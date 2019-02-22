
include version.mk
BASE_VERSION=$(IMAGE_VERSION)
PREV_VERSION = 0.0.0
BASEIMAGE_RELEASE=0.0.1

IS_RELEASE = true
EXPERIMENTAL ?= false

ifneq ($(IS_RELEASE),true)
EXTRA_VERSION ?= snapshot-$(shell git rev-parse --short HEAD)
PROJECT_VERSION=$(BASE_VERSION)-$(EXTRA_VERSION)
else
PROJECT_VERSION=$(BASE_VERSION)
endif

PKGNAME = github.com/helloshiki/go-docker-demo
CGO_FLAGS = CGO_CFLAGS=" "
#ARCH=$(shell uname -m)
MARCH=$(shell go env GOOS)-$(shell go env GOARCH)

# defined in common/metadata/metadata.go
# METADATA_VAR = Version=$(PROJECT_VERSION)
# METADATA_VAR += BuildTimestamp=$(shell date +%Y%m%d-%H:%M:%S)

GO_LDFLAGS = $(patsubst %,-X $(PKGNAME)/common/metadata.%,$(METADATA_VAR))

GO_TAGS ?=

export GO_LDFLAGS
export GO_TAGS


GOIMAGES = demo web

gopkgmap.web                 := $(PKGNAME)/web
gopkgmap.demo                := $(PKGNAME)/demo

include docker-env.mk

all: native docker

build/bin:
	mkdir -p $@

build/bin/%: # TODO: file list
	@mkdir -p $(@D)
	@echo "$@"
	$(CGO_FLAGS) GOBIN=$(abspath $(@D)) go install -tags "$(GO_TAGS)" -ldflags "$(GO_LDFLAGS)" $(gopkgmap.$(@F))
	@echo "Binary available as $@"
	@touch $@

build/bin/web:
	#cd web && [ -e node_modules ] || npm install
	#cd web && npm run build
	@echo "building web"

build/bin/%-clean:
	@echo "$@"
	$(eval TARGET = $(patsubst %-clean, %, $(@F)))
	-@rm -rf build/bin/$(TARGET) ||:
	@echo "Clean binary build/bin/$(TARGET)"

build/docker/bin/%:
	@mkdir -p $(@D)
	@echo "Building $@"
	$(CGO_FLAGS) GOBIN=$(abspath $(@D)) go install -tags "$(GO_TAGS)" -ldflags "$(GO_LDFLAGS)" $(gopkgmap.$(@F))
	@echo "Binary available as $@"
	@touch $@

build/image/web/payload: images/web/config web/dist
build/image/demo/payload: build/docker/bin/demo

build/image/%/payload:
	mkdir -p $@
	-cp $^ $@/ -rf

.PRECIOUS: build/image/%/Dockerfile

build/image/%/Dockerfile: images/%/Dockerfile.in
	$(eval TARGET = ${patsubst build/image/%/Dockerfile,%,${@}})
	@echo $(TARGET)
	@cat $< \
		| sed -e 's/_BASE_TAG_/$(BASE_DOCKER_TAG)/g' \
		| sed -e 's/_TAG_/$(DOCKER_TAG)/g' \
		| sed -e 's/_CAPP_NAME_/$(TARGET).exe/g' \
		| sed -e 's/_APP_NAME_/$(TARGET)/g' \
		> $@
	@echo "LABEL $(BASE_DOCKER_LABEL).version=$(PROJECT_VERSION) \\">>$@
	@echo "     " $(BASE_DOCKER_LABEL).base.version=$(BASEIMAGE_RELEASE)>>$@

build/image/%/$(DUMMY): Makefile build/image/%/payload build/image/%/Dockerfile
	$(eval TARGET = ${patsubst build/image/%/$(DUMMY),%,${@}})
	@echo "Building docker $(TARGET)-image"
	$(DBUILD) -t $(DOCKER_NS)/demo-$(TARGET):$(DOCKER_TAG) $(@D)
	@touch $@

build/image/web/$(DUMMY): Makefile build/image/web/payload build/image/web/Dockerfile

.PHONY: web
web: build/bin/web
web-docker: build/image/web/$(DUMMY)

.PHONY: demo
demo: build/bin/demo
demo-docker: build/image/demo/$(DUMMY)

native: demo web
docker: demo-docker web-docker


%-clean: build/bin/%-clean
	@echo "End exec $@"

%-docker-clean:
	$(eval TARGET = ${patsubst %-docker-clean,%,${@}})
	-@rm -rf build/docker/bin
	#-docker images -q $(DOCKER_NS)/tcc-$(TARGET) | xargs -I '{}' docker rmi -f '{}'
	-@rm -rf build/image/$(TARGET) ||:

docker-clean: $(patsubst %, %-docker-clean, $(GOIMAGES))

native-clean: $(patsubst %, %-clean, $(GOIMAGES))

.PHONY: clean
clean: docker-clean native-clean
