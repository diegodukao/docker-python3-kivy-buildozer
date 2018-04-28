FROM python:3.6-stretch

ENV PATH /usr/local/bin:$PATH

WORKDIR /src

ADD . /src

RUN dpkg --add-architecture i386

RUN apt-get update && apt-get install -y -q \
    build-essential \
    sudo \
    bsdtar \
    git \
    ffmpeg \
    libsdl2-dev \
    libsdl2-image-dev \
    libsdl2-mixer-dev \
    libsdl2-ttf-dev \
    libportmidi-dev \
    libswscale-dev \
    libavformat-dev \
    libavcodec-dev \
    zlib1g-dev \
    libgstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    libgstreamer1.0-dev \
    openjdk-8-jdk \
    ccache \
    unzip \
    libncurses5:i386 \
    libstdc++6:i386 \
    libgtk2.0-0:i386 \
    libpangox-1.0-0:i386 \
    libpangoxft-1.0-0:i386 \
    libidn11:i386 \
    zlib1g:i386

RUN pip install --trusted-host pypi.python.org -r requirements-INSTALL-FIRST.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

RUN set -ex \
    && useradd kivy -mN \
    && echo "kivy:kivy" | chpasswd \
    && chown kivy:users /opt \
    && chown kivy:users /src


RUN set -ex \
    && sudo -u kivy -i \
    && cd /opt \
    && git clone https://github.com/kivy/buildozer \
    && cd buildozer \
    && python setup.py build \
    && pip install -e . \
    && sed -i -e 's/build.gradle/~build.gradle/g' /opt/buildozer/buildozer/targets/android.py

RUN set -ex \
    && sudo -u kivy -i \
    && cd /opt \
    && bsdtar xf /src/crystax-ndk-10.3.2-linux-x86_64.tar.xz

RUN ln -s /usr/local/bin/buildozer /bin/buildozer

RUN mkdir /buildozer && chown kivy /buildozer

USER kivy
