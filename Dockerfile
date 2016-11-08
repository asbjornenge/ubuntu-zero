## Ubuntu with ZeroTier base image
#
FROM ubuntu:16.04 
MAINTAINER Asbjorn Enge <asbjorn@hanafjedle.net> 

# Update & Install
RUN apt-get -qq update
RUN apt-get -qq -y install curl
RUN apt-get -qq -y install python
RUN apt-get -qq -y install nodejs

# Add ZT files
ADD liblwip.so / 
ADD libztintercept.so /
ADD zerotier-sdk-service /
ADD zerotier-one /
ADD zerotier-cli /zerotier-cli
ADD init-zerotier.sh /usr/local/bin/init-zerotier
ADD app.sh /usr/local/bin/app
ADD app.js /

EXPOSE 9993/udp
