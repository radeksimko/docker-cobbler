# docker-cobbler

Docker image for [Cobbler](http://cobbler.github.io/).

## Purpose

The main motivation behind this Docker image was to have an image that can be used as a target
when running [Terraform Cobbler Provider](https://github.com/terraform-providers/terraform-provider-cobbler) acceptance tests.

Do **NOT run anywhere near production**, but feel free to fork and create your own production-ready image, and/or contribute back.

## Endpoints

 - Web: https://127.0.0.1/cobbler_web
 - API: https://127.0.0.1/cobbler_api
 - Default credentials: cobbler/cobbler

## How

### How to Pull

```
docker pull radeksimko/cobbler
```

### How to Build

In case you prefer to build things yourselves for any reason:

```
docker build . -t radeksimko/cobbler
```

### How to Launch

```
docker run -d \
	--cap-add SYS_ADMIN \
	-p 443:443 \
	--name cobbler \
	radeksimko/cobbler
```

### How to Stop Gracefully

```
docker exec -i cobbler /usr/sbin/init 0
```

### How to import OS

```
docker exec -ti cobbler wget -O /tmp/ubuntu-14.04-server-amd64 http://old-releases.ubuntu.com/releases/14.04.2/ubuntu-14.04-server-amd64.iso
docker exec -i cobbler 7z x -o/workspace/ubuntu /tmp/ubuntu-14.04-server-amd64
docker exec -i cobbler cobbler import --name Ubuntu-14.04 --breed ubuntu --os-version=trusty --arch=x86_64 --path /workspace/ubuntu
docker exec -i cobbler cobbler sync
```

## Why

### systemd

Most Docker images avoid systemd when there's a single process to launch inside the container.
Unfortunately Cobbler requires more than a single process, hence there's need for a service manager such as systemd inside the container.

Making systemd work inside Docker requires non-trivial changes in the image and the way it runs.

 - https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html/managing_containers/using_systemd_with_containers
 - https://github.com/moby/moby/issues/7459
 - https://github.com/moby/moby/issues/30723
 - https://github.com/CentOS/sig-cloud-instance-images/issues/55
