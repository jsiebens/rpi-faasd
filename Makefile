define build_image
	rm ${PWD}/dist/$1.img || true
	rm -rf ${PWD}/output-arm-image
	docker run \
		--rm \
		--privileged \
		-v ${PWD}:/build:ro \
		-v ${PWD}/packer_cache:/build/packer_cache \
		-v ${PWD}/output-arm-image:/build/output-arm-image \
		-e PREFERRED_MIRROR \
		quay.io/solo-io/packer-builder-arm-image:v0.1.4.5 build -var-file=/build/packer/variables.json "/build/packer/$1.json"
	mkdir -p ${PWD}/dist
	mv ${PWD}/output-arm-image/image ${PWD}/dist/$1.img
	rm -rf ${PWD}/output-arm-image
endef

.PHONY = %

SRCS := $(wildcard packer/rpi-*.json)
IMAGES := $(SRCS:packer/rpi-%.json=rpi-%.img)
ARCHIVES := $(SRCS:packer/rpi-%.json=rpi-%.zip)

all: ${IMAGES}

dist: ${ARCHIVES}

clean:
	rm -rf dist

%.img:
	$(call build_image,$*)

%.zip: %.img
	rm -rf dist/$@
	cd dist; zip $@ $<