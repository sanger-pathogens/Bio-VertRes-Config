FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer=path-help@sanger.ac.uk

# install system deps
RUN apt-get -qq update && \
	apt-get install --quiet --assume-yes locales git curl cpanminus build-essential libssl-dev libcrypt-ssleay-perl dh-dist-zilla && \
 	apt-get clean

# fix locales
RUN   sed -i -e 's/# \(en_GB\.UTF-8 .*\)/\1/' /etc/locale.gen && \
      touch /usr/share/locale/locale.alias && \
      locale-gen
ENV   LANG     en_GB.UTF-8
ENV   LANGUAGE en_GB:en
ENV   LC_ALL   en_GB.UTF-8

# copy and install (with perl deps)
COPY . /opt/Bio-VertRes-Config
WORKDIR /opt/Bio-VertRes-Config
RUN	dzil authordeps --missing | cpanm --force && \
    cpanm Pod::Elemental::Transformer::List && \
	dzil listdeps --missing | cpanm --force && \
	dzil test && \
	dzil install
