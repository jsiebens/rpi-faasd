define build_image
	rm ${PWD}/dist/rpi-$1.iso || true
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
	mv ${PWD}/output-arm-image/image ${PWD}/dist/rpi-$1.iso
	rm -rf ${PWD}/output-arm-image
endef

.PHONY: all
all: faasd faasd-inlets-oss faasd-inlets-pro

.PHONY: faasd
faasd:
	$(call build_image,faasd)

.PHONY: faasd-inlets-oss
faasd-inlets-oss:
	$(call build_image,faasd-inlets-oss)

.PHONY: faasd-inlets-pro
faasd-inlets-pro:
	$(call build_image,faasd-inlets-pro)