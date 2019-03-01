FROM centos:7.6.1810

ENV container docker

RUN yum -y install \
	epel-release \
	yum-plugin-ovl

# Install dependencies
RUN yum -y install \
	debmirror \
	pykickstart \
	curl \
	wget \
	file \
	fence-agents-all

# Install 7zip for upacking ISOs (as we can't mount them in Docker)
RUN yum -y install p7zip p7zip-plugins

# Install older version of Django because cobbler-web fails with
# 1.11.18 which is the latest available as of writing.
# See https://github.com/cobbler/cobbler/issues/1717
RUN yum -y install python2-django16

# Install Cobbler
RUN yum -y install cobbler cobbler-web

# Remove unnecessary systemd services
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup", "/workspace" ]

# Enable all services
RUN systemctl enable rsyncd && \
	systemctl enable httpd && \
	systemctl enable cobblerd

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/init"]
