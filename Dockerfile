FROM ubuntu:16.04

MAINTAINER Lam Hoang "lamhx393@gmail.com"

# Update apt-get
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install -y gcc g++

# Installing packages
RUN apt-get install -y \
  autoconf \
  automake \
  ant \
  build-essential \
  bzip2 \
  curl \
  cmake \
  coreutils \
  git \
  groff \
  lib32stdc++6 \
  lib32z1 \
  lib32z1-dev \
  lib32ncurses5 \
  libc6-dev \
  libgmp-dev \
  libmpc-dev \
  libmpfr-dev \
  libxslt-dev \
  libxml2-dev \
  libssl-dev \
  libtool \
  m4 \
  make \
  ncurses-dev \
  ocaml \
  opam \
  openssh-client \
  openjdk-8-jdk \
  pkg-config \
  python2.7 \
  python-dev \
  rsync \
  software-properties-common \
  unzip \
  wget \
  zip \
  zlib1g-dev \
  --no-install-recommends

# i386
RUN dpkg --add-architecture i386
RUN apt-get update -qq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libstdc++5:i386 libgcc1:i386 libncurses5:i386 libz1:i386 zip p7zip-full

#Android ENV
ENV SDK_TOOLS "4333796"
ENV BUILD_TOOLS "28.0.3"
ENV TARGET_SDK "28"
ENV ANDROID_HOME "/opt/android-sdk-linux"
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Download and extract Android Tools
RUN wget http://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS}.zip -O /tmp/tools.zip && \
	mkdir -p ${ANDROID_HOME} && \
	unzip /tmp/tools.zip -d ${ANDROID_HOME} && \
	rm -v /tmp/tools.zip

# Install SDK Packages
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg && \
	yes | ${ANDROID_HOME}/tools/bin/sdkmanager "--licenses" && \
	${ANDROID_HOME}/tools/bin/sdkmanager "--update" && \
	${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"

#Android NDK
ENV PWD /opt
WORKDIR $PWD
# Android NDK
ENV ANDROID_NDK_VERSION r15c
ENV ANDROID_NDK_URL http://dl.google.com/android/repository/android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
RUN curl -L "${ANDROID_NDK_URL}" -o android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip  \
  && unzip android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip -d ${PWD}  \
  && rm -rf android-ndk-${ANDROID_NDK_VERSION}-linux-x86_64.zip
ENV ANDROID_NDK_HOME ${PWD}/android-ndk-${ANDROID_NDK_VERSION}
ENV PATH ${ANDROID_NDK_HOME}:$PATH
RUN chmod +x ${ANDROID_NDK_HOME}/ndk-build
