FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV FORCE_UNSAFE_CONFIGURE 1

RUN apt-get update && \
    apt-get install -y \
    pkg-config libudev-dev \
    build-essential make ncurses-dev  g++ gcc git gzip \
    bash bc binutils build-essential bzip2 cpio \
    locales libncurses5-dev libdevmapper-dev libsystemd-dev make \
    mercurial whois patch perl python rsync sed \
    tar vim unzip wget bison flex libssl-dev libfdt-dev

RUN git clone https://github.com/furkantokac/buildroot

WORKDIR /buildroot

ENTRYPOINT /bin/bash
