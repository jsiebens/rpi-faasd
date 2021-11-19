# faasd on a Raspberry Pi

![main](https://github.com/jsiebens/rpi-faasd/actions/workflows/build.yaml/badge.svg?branch=main)

Blog post: [A serverless appliance for your Raspberry Pi with faasd](https://johansiebens.dev/posts/2020/08/a-serverless-appliance-for-your-raspberry-pi-with-faasd/)

This repository contains Packer templates and scripts to build a Raspbian image with [faasd](https://github.com/openfaas/faasd) and [inlets](https://inlets.dev) [oss](https://github.com/inlets/inlets)/[pro](https://github.com/inlets/inlets-pro) pre-installed.

> faasd is the same OpenFaaS experience and ecosystem, but without Kubernetes. Functions and microservices can be deployed anywhere with reduced overheads whilst retaining the portability of containers and cloud-native tooling such as containerd and CNI.

The installation took inspiration from the [blog of Alex Ellis](https://blog.alexellis.io/faasd-for-lightweight-serverless/), which explains how to install faasd on a Raspberry Pi in more detail.

Beside containerd, faasd and inlets, also [cloud-init](https://cloudinit.readthedocs.io/en/18.3/) is available to initialize and configure a Raspian instance. With cloud-init you can customize e.g. hostname, authorized ssh keys, a static ip, basic auth for faasd, ... 

This setup includes the following images:

- __rpi-faasd__: a Raspios/Ubuntu image with containerd and faasd as systemd services, to run a private faasd instance.

## How to use these images

### in general

1. Download the image of the latest [release](https://github.com/jsiebens/rpi-faasd/releases) or build the image.

2. Flash the image to an SD card.

3. Optionally customize the /boot/user-data with e.g. authorized ssh keys, basic auth credentials ...

4. Insert the SD card into the Raspberry Pi and power it up.

5. As soon the services are up and running, you can access OpenFaas on `http://<your raspberry pi ip>:8080`. The required basic auth credentials are available in `/var/lib/faasd/secrets/` on your Raspberry Pi

### in combination with inlets-pro

To expose the faasd gateway running on a Raspberry Pi, you need to create an exit-node with a public ip.
I find the use of [inletsctl](https://github.com/inlets/inletsctl) to easist way to achieve this. Download the latest release or simply install it by running `curl -sSLf https://inletsctl.inlets.dev | sudo sh`

Next, create an HTTP exit-node on your favourite cloud provider, e.g. on DigitalOcean:

```
inletsctl create  \
  --tcp=false \   
  --provider digitalocean \   
  --access-token-file ~/access-token.txt \   
  --region lon1 \
  --letsencrypt-domain <your domain>
  --letsencrypt-email <your email>
```

After writing the `rpi-faasd` image to an SD card, configure your instance with the proper values for the required environment variables. (See examples/user-data-inlets)

## Building the images

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

When connected with the Vagrant box, run `build.sh` in the `/vagrant` directory:

```
cd /vagrant
./build.sh
```