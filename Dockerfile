FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer=path-help@sanger.ac.uk

# install system deps
RUN apt-get -qq update && \
	apt-get install --quiet --assume-yes libmysqlclient-dev locales git curl cpanminus build-essential libssl-dev libcrypt-ssleay-perl dh-dist-zilla && \
 	apt-get clean

# fix locales
RUN   sed -i -e 's/# \(en_GB\.UTF-8 .*\)/\1/' /etc/locale.gen && \
      touch /usr/share/locale/locale.alias && \
      locale-gen
ENV   LANG     en_GB.UTF-8
ENV   LANGUAGE en_GB:en
ENV   LC_ALL   en_GB.UTF-8


# This RUN will install known Perl dependencies ahead of the automatic 
# installation by with `dzil authordeps` and `dzil listdeps` (below). Adding this 
# RUN  will cache these in a Docker layer makes the build much faster you have 
# only made a change in the Bio-VertRes-Config repo (just a one-line change 
# triggers the COPY command below and causes all the Perl dependencies to be 
# reinstalled).
# *But* it will make the image larger, and could in future install packages that
# are no longer required.
# => NOT recommended for production builds
# 
# use --build-arg "FAST_REBUILDS=true" to enable this
# 
ARG   FAST_REBUILDS
RUN   if [ "$FAST_REBUILDS" = "true" ]; then \
         echo 'Installing known dependencies in separate layer to speed up docker repeated builds (not recommended for production)'; \
         cpanm Dist::Zilla::Plugin::PodWeaver \
               Dist::Zilla::PluginBundle::Git \
               Pod::Elemental::Transformer::List \
               Array::Utils \
               DBI \
               File::Slurper \
               Test::Files \
               Pod::Elemental::Transformer::List \
               DBD::mysql; \
      fi

# Dist::Zilla::PluginBundle::Starter tests fail unless Dist::Zilla has been
# installed first.  Doing this allows the --force option than was previously
# used with cpanm (below) to be removed.
RUN   cpanm Dist::Zilla && \
      cpanm Dist::Zilla::PluginBundle::Starter

# copy and install (with perl deps)
# note tests include looking for user 'pathpipe'
COPY     . /opt/Bio-VertRes-Config
WORKDIR  /opt/Bio-VertRes-Config
RUN      dzil authordeps --missing | cpanm && \
         cpanm Pod::Elemental::Transformer::List && \
         cpanm DBD::mysql && \
         dzil listdeps --missing | cpanm && \
         adduser --system pathpipe && \
         dzil test && \
         deluser pathpipe && \
         dzil install
