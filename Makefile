.PHONY = %

SRCS := $(wildcard packer/rpi-*.json)
IMAGES := $(SRCS:packer/rpi-%.json=rpi-%.img)
ARCHIVES := $(SRCS:packer/rpi-%.json=rpi-%.zip)

all: ${IMAGES}

dist: ${ARCHIVES}

clean:
	rm -rf dist

%.img:
	sudo packer build -var-file=packer/variables.json "packer/$*.json"
	mkdir -p dist
	mv output-arm-image/image dist/$*.img
	rm -rf output-arm-image

%.zip: %.img
	rm -rf dist/$@
	cd dist; zip $@ $<