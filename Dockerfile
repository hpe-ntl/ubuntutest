FROM       ubuntu:16.04
MAINTAINER Pablo Saenz psaenz@hpe.com 

ENV container docker
ENV DEBIAN_FRONTEND noninteractive
ENV http_proxy http://web-proxy.houston.hpecorp.net:8080
ENV https_proxy http://web-proxy.houston.hpecorp.net:8080

RUN echo "APT::Get::Install-Recommends 'false'; \n\
  APT::Get::Install-Suggests 'false'; \n\
  APT::Get::Assume-Yes "true"; \n\
  APT::Get::force-yes "true";" > /etc/apt/apt.conf.d/00-general

RUN apt-get update

RUN apt-get install -y openssh-server nmap iperf tcpdump vlan iproute net-tools inetutils*
RUN mkdir /var/run/sshd

RUN echo 'root:procurve' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]
