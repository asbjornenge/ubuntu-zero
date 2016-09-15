## Ubuntu with ZeroTier base image
#
FROM ubuntu:16.04 
MAINTAINER Asbjorn Enge <asbjorn@hanafjedle.net> 

# Update & Install
RUN apt-get -qq update
RUN apt-get -qq -y install curl

# Add ZT files
RUN mkdir -p /var/lib/zerotier-one/networks.d
ADD liblwip.so /var/lib/zerotier-one/liblwip.so
ADD libztintercept.so /
RUN cp libztintercept.so lib/libztintercept.so
RUN ln -sf /lib/libztintercept.so /lib/libzerotierintercept
ADD zerotier-cli /
Add zerotier-sdk-service /
ADD init-zerotier.sh /usr/local/bin/init-zerotier

EXPOSE 9993/udp
