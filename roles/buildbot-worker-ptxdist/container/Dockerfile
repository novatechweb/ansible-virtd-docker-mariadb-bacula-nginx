#
# Build the main image
#
FROM        ubuntu:14.04
WORKDIR /buildbot


#
# Install security updates and required packages
#
RUN apt-get update \
&&  DEBIAN_FRONTEND=noninteractive \
    apt-get -y install -q \
        autoconf \
        bc \
        bison \
        build-essential \
        comerr-dev \
        curl \
        default-jre-headless \
        docbook-xml \
        docbook-xsl \
        groff-base \
        libffi-dev \
        libgdk-pixbuf2.0-dev \
        libgtk2.0-bin \
        libicu-dev \
        libncurses5 \
        libncurses5-dev \
        libpq-dev \
        libssl-dev \
        libswitch-perl \
        libxml-simple-perl \
        libxml2-utils \
        lzop \
        flex \
        gawk \
        gcc \
        gconf2 \
        gettext \
        git \
        libtool \
        make \
        python-dev \
        python-libxml2 \
        python-tdb \
        ruby \
        subversion \
        ss-dev \
        texinfo \
        unzip \
        wget \
        xsltproc \
        yasm \
        zlib1g-dev \
&&  rm -rf /var/lib/apt/lists/*

ENV DUMB_INIT_VERSION 1.2.2
ENV DUMB_INIT_SHA256 026ebfec4883479e9ab1e3efa96e59b4317e50da27fff46cd81bfd132663249a
ENV DUMB_INIT_URL https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64.deb
ENV DUMB_INIT_FILE /tmp/dumb-init_${DUMB_INIT_VERSION}_amd64.deb

# Test runs produce a great quantity of dead grandchild processes.  In a
# non-docker environment, these are automatically reaped by init (process 1),
# so we need to simulate that here.  See https://github.com/Yelp/dumb-init
RUN curl -fLS "${DUMB_INIT_URL}" -o "${DUMB_INIT_FILE}" \
&&  echo "${DUMB_INIT_SHA256}" "${DUMB_INIT_FILE}" | sha256sum -c \
&&  dpkg -i "${DUMB_INIT_FILE}" \
&&  rm -f "${DUMB_INIT_FILE}"

#
# Build and install python, pip, twisted, and buildbot
#
ENV BUILDBOT_PYTHON="3.6.12"
ENV PYTHON_URL https://www.python.org/ftp/python/${BUILDBOT_PYTHON}/Python-${BUILDBOT_PYTHON}.tgz
ENV PYTHON_MD5 00c3346f314072fcc810d4a51d06f04e
ENV PYTHON_ARCHIVE /tmp/Python-${BUILDBOT_PYTHON}.tgz

RUN curl -fLS "${PYTHON_URL}" -o "${PYTHON_ARCHIVE}" \
&&  echo "${PYTHON_MD5}" "${PYTHON_ARCHIVE}" | md5sum -c \
&&  tar -xz -C /tmp -f "${PYTHON_ARCHIVE}" \
&&  cd "/tmp/Python-${BUILDBOT_PYTHON}" \
&&  ./configure --enable-optimizations \
&&  make -j8 \
&&  make install \
&&  cd /tmp \
&&  rm -rf "/tmp/Python-${BUILDBOT_PYTHON}"

ARG BUILDBOT_VERSION
RUN python3 -m pip --no-cache-dir install \
    'twisted[tls]' \
    buildbot-worker==${BUILDBOT_VERSION}


#
# Create buildbot user
#
ARG BUILDBOT_GID=1000
ARG BUILDBOT_UID=1000
COPY buildbot/ /home/buildbot/
RUN groupadd --gid ${BUILDBOT_GID} buildbot \
&&  useradd --comment "Buildbot Server" -g buildbot --home-dir "/home/buildbot" --shell "/bin/bash" --uid ${BUILDBOT_UID} buildbot \
&&  mkdir -p --mode=0700 "/home/buildbot/.ssh" \
&&  chown -v -R buildbot:buildbot "/buildbot" \
&&  chown -v -R buildbot:buildbot "/home/buildbot" \
&&  useradd --comment "Gnome Display Manager" --home-dir "/var/lib/gdm" --shell "/sbin/nologin" --user-group --system gdm \
&&  mkdir --mode=0777 -p /opt \
&&  chown -R buildbot:buildbot /opt


#
# Build PTXdist release 2011.11.0
#
COPY ptxdist /tmp
RUN PTXDIST_REPO=https://git.novatech-llc.com/Orion-ptxdist/ptxdist.git \
&&  PTXDIST_BRANCH=stable/ptxdist-2011.11.x \
&&  PTXDIST_VERSION=2011.11.0 \
&&  git clone --branch ${PTXDIST_BRANCH} ${PTXDIST_REPO} ptxdist-${PTXDIST_VERSION} \
&&  cd ptxdist-${PTXDIST_VERSION} \
&&  git config user.name "Buildbot" \
&&  git config user.email "buildbot@novatech-llc.com" \
&&  git am /tmp/ptxdist-${PTXDIST_VERSION}/*.patch \
&&  git tag -f -a -m"Tag updated version of ${PTXDIST_VERSION}" "ptxdist-${PTXDIST_VERSION}" \
&&  ./autogen.sh \
&&  ./configure \
&&  make \
&&  make install \
&&  cd .. && rm -r ptxdist-${PTXDIST_VERSION}


#
# Build PTXdist release 2012.12.1
#
RUN PTXDIST_REPO=https://git.novatech-llc.com/Orion-ptxdist/ptxdist.git \
&&  PTXDIST_BRANCH=stable/ptxdist-2012.12.x \
&&  PTXDIST_VERSION=2012.12.1 \
&&  git clone --branch ${PTXDIST_BRANCH} ${PTXDIST_REPO} ptxdist-${PTXDIST_VERSION} \
&&  cd ptxdist-${PTXDIST_VERSION} \
&&  ./autogen.sh \
&&  ./configure \
&&  make \
&&  make install \
&&  cd .. && rm -r ptxdist-${PTXDIST_VERSION}


#
# Build PTXdist release 2012.09.1
#
RUN PTXDIST_REPO=https://git.novatech-llc.com/Orion-ptxdist/ptxdist.git \
&&  PTXDIST_BRANCH=master \
&&  PTXDIST_VERSION=2012.09.1 \
&&  git clone --branch ${PTXDIST_BRANCH} ${PTXDIST_REPO} ptxdist-${PTXDIST_VERSION} \
&&  cd ptxdist-${PTXDIST_VERSION} \
&&  git config user.name "Buildbot" \
&&  git config user.email "buildbot@novatech-llc.com" \
&&  touch ptxdist \
&&  echo "${PTXDIST_VERSION}" > .tarball-version \
&&  git tag -f -a -m"Tag custom ${PTXDIST_VERSION} build" "ptxdist-${PTXDIST_VERSION}" \
&&  ./autogen.sh \
&&  ./configure \
&&  make \
&&  make install \
&&  cd .. && rm -r ptxdist-${PTXDIST_VERSION}


#
# Switch to buildbot user
#   (ptxdist refuses to run as root)
#
USER buildbot


#
# Build OSELAS Toolchain 2011.11.3 for armeb-xscale
#
RUN PTXDIST=/usr/local/bin/ptxdist-2011.11.0 \
&&  TOOLCHAIN_REPO=https://git.novatech-llc.com/Orion-ptxdist/OSELAS.Toolchain \
&&  TOOLCHAIN_ARCH=armeb-xscale \
&&  TOOLCHAIN_BRANCH=OSELAS.Toolchain-2011.11.x \
&&  TOOLCHAIN_CONFIG=armeb-xscale-linux-gnueabi_gcc-4.6.4_glibc-2.14.1_binutils-2.21.1a_kernel-2.6.39-sanitized.ptxconfig \
&&  git clone --branch ${TOOLCHAIN_BRANCH} ${TOOLCHAIN_REPO} toolchain-${TOOLCHAIN_ARCH} \
&&  cd toolchain-${TOOLCHAIN_ARCH} \
&&  ${PTXDIST} select ptxconfigs/${TOOLCHAIN_CONFIG} \
&&  ${PTXDIST} go \
&&  cd .. && rm -r toolchain-${TOOLCHAIN_ARCH}


#
# Build OSELAS Toolchain 2012.12.1 for arm-cortexa8
#
RUN PTXDIST=/usr/local/bin/ptxdist-2012.12.1 \
&&  TOOLCHAIN_REPO=https://git.novatech-llc.com/Orion-ptxdist/OSELAS.Toolchain \
&&  TOOLCHAIN_ARCH=am335x \
&&  TOOLCHAIN_BRANCH=OSELAS.Toolchain-2012.12.x \
&&  TOOLCHAIN_CONFIG=arm-cortexa8-linux-gnueabi_gcc-4.7.3_glibc-2.16.0_binutils-2.22_kernel-3.6-sanitized.ptxconfig \
&&  git clone --branch ${TOOLCHAIN_BRANCH} ${TOOLCHAIN_REPO} toolchain-${TOOLCHAIN_ARCH} \
&&  cd toolchain-${TOOLCHAIN_ARCH} \
&&  ${PTXDIST} select ptxconfigs/${TOOLCHAIN_CONFIG} \
&&  ${PTXDIST} go \
&&  cd .. && rm -r toolchain-${TOOLCHAIN_ARCH}


#
# Build OSELAS Toolchain 2012.12.1 for i686
#
RUN PTXDIST=/usr/local/bin/ptxdist-2012.12.1 \
&&  TOOLCHAIN_REPO=https://git.novatech-llc.com/Orion-ptxdist/OSELAS.Toolchain \
&&  TOOLCHAIN_ARCH=i686 \
&&  TOOLCHAIN_BRANCH=OSELAS.Toolchain-2012.12.x \
&&  TOOLCHAIN_CONFIG=i686-atom-linux-gnu_gcc-4.7.4_glibc-2.16.0_binutils-2.22_kernel-3.6-sanitized.ptxconfig \
&&  git clone --branch ${TOOLCHAIN_BRANCH} ${TOOLCHAIN_REPO} toolchain-${TOOLCHAIN_ARCH} \
&&  cd toolchain-${TOOLCHAIN_ARCH} \
&&  ${PTXDIST} select ptxconfigs/${TOOLCHAIN_CONFIG} \
&&  ${PTXDIST} go \
&&  cd .. && rm -r toolchain-${TOOLCHAIN_ARCH}


#
# Final image settings
#
USER buildbot
CMD ["/home/buildbot/start.sh"]
