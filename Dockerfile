FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update && \
	apt-get install --quiet --assume-yes git curl cpanminus build-essential libssl-dev libcrypt-ssleay-perl dh-dist-zilla && \
 	apt-get clean

COPY . /opt/Bio-VertRes-Config
WORKDIR /opt/Bio-VertRes-Config

RUN	dzil authordeps --missing | cpanm --force && \
    cpanm Pod::Elemental::Transformer::List && \
	dzil listdeps --missing | cpanm --force && \
	dzil test && \
	dzil install
