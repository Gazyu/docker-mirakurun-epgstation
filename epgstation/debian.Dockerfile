FROM l3tnun/epgstation:master-debian

ENV DEV="make gcc git g++ automake curl wget autoconf build-essential libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev"
ENV FFMPEG_VERSION=7.0

RUN mkdir -p /app/config /app/data /app/thumbnail /app/logs /app/recorded && \
    apt-get update && \
    apt-get -y install $DEV && \
    curl -o /app/config/enc.js https://raw.githubusercontent.com/l3tnun/docker-mirakurun-epgstation/refs/heads/v2/epgstation/config/enc.js.template  && \
    curl -o /app/config/config.yml https://raw.githubusercontent.com/l3tnun/docker-mirakurun-epgstation/refs/heads/v2/epgstation/config/config.yml.template  && \
    curl -o /app/config/operatorLogConfig.yml https://raw.githubusercontent.com/l3tnun/docker-mirakurun-epgstation/refs/heads/v2/epgstation/config/operatorLogConfig.sample.yml  && \
    curl -o /app/config/epgUpdaterLogConfig.yml https://raw.githubusercontent.com/l3tnun/docker-mirakurun-epgstation/refs/heads/v2/epgstation/config/epgUpdaterLogConfig.sample.yml  && \
    curl -o /app/config/serviceLogConfig.yml https://raw.githubusercontent.com/l3tnun/docker-mirakurun-epgstation/refs/heads/v2/epgstation/config/serviceLogConfig.sample.yml  && \
    apt-get -y install yasm libx264-dev libmp3lame-dev libopus-dev libvpx-dev && \
    apt-get -y install libx265-dev libnuma-dev && \
    apt-get -y install libasound2 libass9 libvdpau1 libva-x11-2 libva-drm2 libxcb-shm0 libxcb-xfixes0 libxcb-shape0 libvorbisenc2 libtheora0 libaribb24-dev && \
\
#ffmpeg build
    mkdir /tmp/ffmpeg_sources && \
    cd /tmp/ffmpeg_sources && \
    curl -fsSL http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | tar -xj --strip-components=1 && \
    ./configure \
      --prefix=/usr/local \
      --disable-shared \
      --pkg-config-flags=--static \
      --enable-gpl \
      --enable-libass \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-version3 \
      --enable-libaribb24 \
      --enable-nonfree \
      --disable-debug \
      --disable-doc \
    && \
    make -j$(nproc) && \
    make install && \
\
# 不要なパッケージを削除
    apt-get -y remove $DEV && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*
