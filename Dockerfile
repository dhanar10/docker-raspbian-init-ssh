FROM scratch

ARG DEBIAN_FRONTEND=noninteractive

ENV container docker

ADD root.tar.xz /
ADD boot.tar.xz /boot/

COPY qemu-arm-static /usr/bin
RUN sed -i 's/^/#/' /etc/ld.so.preload

COPY detect-apt-proxy.sh /usr/bin
RUN chmod +x /usr/bin/detect-apt-proxy.sh \
    && echo 'Acquire::http::ProxyAutoDetect "/usr/bin/detect-apt-proxy.sh";' \
       | tee /etc/apt/apt.conf.d/00aptproxy

RUN apt-get update \
	&& apt-get install -y \
        python3-pip \
        screen \
	&& rm -rf /var/lib/apt/lists/*
	
RUN dpkg-reconfigure openssh-server \
	&& systemctl enable ssh \
	&& mkdir /var/run/sshd
	
COPY mdns-proxy.py /usr/local/bin/
COPY slimDNS.py /usr/local/lib/python3.5/dist-packages/
COPY mdns-proxy.service mdns-proxy-resolv.service /etc/systemd/system/
RUN pip3 install dnslib \
	&& chmod +x /usr/local/bin/mdns-proxy.py \
	&& systemctl enable mdns-proxy \
	&& systemctl enable mdns-proxy-resolv \
    && systemctl disable avahi-daemon.socket \
	&& systemctl disable avahi-daemon.service

# https://stackoverflow.com/questions/8671308/non-interactive-method-for-dpkg-reconfigure-tzdata	
	
#RUN ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
#	&& dpkg-reconfigure --frontend noninteractive tzdata

# https://github.com/defn/docker-systemd
	
#RUN find /etc/systemd -name '*.timer' | xargs rm -v \
#	&& systemctl set-default multi-user.target

STOPSIGNAL SIGRTMIN+3

EXPOSE 22

ENTRYPOINT ["/sbin/init"]

CMD []
