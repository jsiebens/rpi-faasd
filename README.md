# faasd on a Raspberry Pi

This repository contains Packer templates and scripts to build a Raspbian image with [faasd](https://github.com/openfaas/faasd) pre-installed.

> faasd is the same OpenFaaS experience and ecosystem, but without Kubernetes. Functions and microservices can be deployed anywhere with reduced overheads whilst retaining the portability of containers and cloud-native tooling such as containerd and CNI.

The installation took inspiration from the [blog of Alex Ellis](https://blog.alexellis.io/faasd-for-lightweight-serverless/), which explains how to install faasd on a Raspberry Pi in more detail.

Beside containerd and faasd, cloud-init is also available to initialize and configure a Raspian instance. With cloud-init you can customize e.g. hostname, authorized ssh keys, a static ip, basic auth for faasd, ... 

This setup includes the following images:

- __rpi-faasd.iso__: a Raspbian image with containerd and faasd as a systemd service

## How to use this image

1. Download the latest release or build the image.

2. Flash the image to an SD card.

3. Optionally customize the /boot/user-data with e.g. authorized ssh keys, basic auth credentials ...

4. Insert the SD card into the Raspberry Pi and power it up.

5. As soon the services are up and running, you can access OpenFaas on http://<your raspberry pi ip>:8080. The required basic auth credentials are available in `/var/lib/faasd/secrets/` on your Raspberry Pi


## Building the image

This project includes a Vagrant file and some scripts to build the images in an isolated environment.

To use the Vagrant environment, start by cloning this repository:

```
git clone https://github.com/jsiebens/rpi-faasd
cd rpi-faasd
```

Next, start the Vagrant box and ssh into it:

```
vagrant up
vagrant ssh
```

When connected with the Vagrant box, run `make` in the `/vagrant` directory:

```
cd /vagrant
make
```