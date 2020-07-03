.PHONY = %

RASPIOS_SRCS := $(wildcard packer/raspios/rpi-*.json)
RASPIOS_IMAGES := $(RASPIOS_SRCS:packer/raspios/rpi-%.json=raspios/rpi-%.img)

UBUNTU_SRCS := $(wildcard packer/ubuntu/rpi-*.json)
UBUNTU_IMAGES := $(UBUNTU_SRCS:packer/ubuntu/rpi-%.json=ubuntu/rpi-%.img)

all: raspios ubuntu

raspios: ${RASPIOS_IMAGES}

ubuntu: ${UBUNTU_IMAGES}

clean:
	rm -rf images
	rm -rf dist

%.img:
	sudo packer build -parallel-builds=1 -var-file=packer/variables.json "packer/$*.json"
