FROM ubuntu:20.04

RUN apt-get update \
 && apt-get upgrade -y

RUN apt-get install -y sudo nano vim git curl wget lsb-release

# Set the locale
RUN apt-get install -y locales && \
   dpkg-reconfigure locales && \
   locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8 \
   LC_ALL=en_US.UTF-8

RUN adduser --disabled-password --gecos '' test
RUN adduser test sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER test

WORKDIR /home/test
