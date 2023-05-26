FROM ubuntu:20.04

MAINTAINER z4yx <z4yx@users.noreply.github.com>

# build with "docker build --build-arg PETA_VERSION=2022.2 --build-arg PETA_RUN_FILE=petalinux-v2022.2-final-installer.run -t petalinux:2022.2 ."

# install dependences:

ARG UBUNTU_MIRROR
RUN [ -z "${UBUNTU_MIRROR}" ] || sed -i.bak s/archive.ubuntu.com/${UBUNTU_MIRROR}/g /etc/apt/sources.list 

RUN dpkg --add-architecture i386 && apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
  sudo \
  locales \
  expect \
  bc \
  rsync \
  libtinfo5 \
  iproute2 \
  gawk \
  python3 \
  python \
  build-essential \
  gcc \
  git \
  make \
  net-tools \
  libncurses5-dev \
  tftpd \
  zlib1g-dev \
  libssl-dev \
  flex \
  bison \
  libselinux1 \
  gnupg \
  wget \
  git-core \
  diffstat \
  chrpath \
  socat \
  xterm \
  autoconf \
  libtool \
  tar \
  unzip \
  texinfo \
  zlib1g-dev \
  gcc-multilib \
  automake \
  zlib1g:i386 \
  screen \
  pax \
  gzip \
  cpio \
  python3-pip \
  python3-pexpect \
  xz-utils \
  debianutils \
  iputils-ping \
  python3-git \
  python3-jinja2 \
  libegl1-mesa \
  libsdl1.2-dev \
  pylint3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*


ARG PETA_VERSION
ARG PETA_RUN_FILE

RUN locale-gen en_US.UTF-8 && update-locale

#make a Vivado user
RUN adduser --disabled-password --gecos '' vivado && \
  usermod -aG sudo vivado && \
  echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY accept-eula.sh ${PETA_RUN_FILE} /

# run the install
RUN chmod a+rx /${PETA_RUN_FILE} && \
  chmod a+rx /accept-eula.sh && \
  mkdir -p /opt/Xilinx && \
  chmod 777 /tmp /opt/Xilinx && \
  cd /tmp && \
  sudo -u vivado -i /accept-eula.sh /${PETA_RUN_FILE} /opt/Xilinx/petalinux && \
  rm -f /${PETA_RUN_FILE} /accept-eula.sh

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash
RUN mkdir -p /tools/Xilinx/PetaLinux

USER vivado
ENV HOME /home/vivado
ENV LANG en_US.UTF-8
RUN mkdir /home/vivado/project
WORKDIR /home/vivado/project

#add vivado tools to path
RUN echo "source /opt/Xilinx/petalinux/settings.sh" >> /home/vivado/.bashrc
