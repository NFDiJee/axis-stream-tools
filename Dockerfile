ARG ARCH=armv7hf
ARG VERSION=12.2.0
ARG UBUNTU_VERSION=24.04
ARG REPO=axisecp
ARG SDK=acap-native-sdk

FROM ${REPO}/${SDK}:${VERSION}-${ARCH}-ubuntu${UBUNTU_VERSION}

ARG ARCH

#-------------------------------------------------------------------------------
# Cross-compile minimal FFmpeg for the target architecture
#-------------------------------------------------------------------------------

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget xz-utils && \
    rm -rf /var/lib/apt/lists/*

ARG FFMPEG_VERSION=6.1.2
WORKDIR /opt/ffmpeg-build

RUN wget -q "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.xz" && \
    tar xf "ffmpeg-${FFMPEG_VERSION}.tar.xz"

# Find the cross-compiler in the SDK and build FFmpeg without sourcing
# the full environment-setup (which sets CC/CFLAGS that conflict with
# FFmpeg's own configure detection).
RUN if [ "$ARCH" = "aarch64" ]; then \
      CROSS_PREFIX=aarch64-linux-gnu- ; \
      FF_ARCH=aarch64 ; \
      SYSROOT=/opt/axis/acapsdk/sysroots/aarch64 ; \
      CC_DIR=/opt/axis/acapsdk/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-poky-linux ; \
    else \
      CROSS_PREFIX=arm-linux-gnueabihf- ; \
      FF_ARCH=arm ; \
      SYSROOT=/opt/axis/acapsdk/sysroots/armv7hf ; \
      CC_DIR=/opt/axis/acapsdk/sysroots/x86_64-pokysdk-linux/usr/bin/arm-poky-linux-gnueabi ; \
    fi && \
    export PATH="${CC_DIR}:/opt/axis/acapsdk/sysroots/x86_64-pokysdk-linux/usr/bin:${PATH}" && \
    cd "ffmpeg-${FFMPEG_VERSION}" && \
    ./configure \
      --enable-cross-compile \
      --cross-prefix=${CROSS_PREFIX} \
      --arch=${FF_ARCH} \
      --target-os=linux \
      --sysroot=${SYSROOT} \
      --enable-gpl \
      --enable-small \
      --enable-network \
      --enable-static \
      --disable-shared \
      --disable-doc \
      --disable-htmlpages \
      --disable-manpages \
      --disable-podpages \
      --disable-txtpages \
      --disable-ffplay \
      --disable-ffprobe \
      --disable-debug \
      --disable-postproc \
      --disable-swscale \
      --disable-everything \
      --enable-indev=lavfi \
      --enable-protocol=file \
      --enable-protocol=pipe \
      --enable-protocol=tcp \
      --enable-protocol=udp \
      --enable-protocol=rtp \
      --enable-protocol=rtmp \
      --enable-protocol=http \
      --enable-demuxer=rtsp \
      --enable-demuxer=sdp \
      --enable-demuxer=rtp \
      --enable-demuxer=flv \
      --enable-demuxer=live_flv \
      --enable-demuxer=mp3 \
      --enable-demuxer=aac \
      --enable-demuxer=wav \
      --enable-demuxer=ogg \
      --enable-demuxer=mov \
      --enable-demuxer=matroska \
      --enable-demuxer=flac \
      --enable-demuxer=lavfi \
      --enable-muxer=flv \
      --enable-encoder=aac \
      --enable-decoder=h264 \
      --enable-decoder=aac \
      --enable-decoder=aac_latm \
      --enable-decoder=mp3 \
      --enable-decoder=mp3float \
      --enable-decoder=pcm_u8 \
      --enable-decoder=pcm_s16le \
      --enable-decoder=pcm_s16be \
      --enable-decoder=pcm_f32le \
      --enable-decoder=flac \
      --enable-decoder=vorbis \
      --enable-parser=h264 \
      --enable-parser=aac \
      --enable-parser=aac_latm \
      --enable-parser=mpegaudio \
      --enable-bsf=h264_mp4toannexb \
      --enable-bsf=aac_adtstoasc \
      --enable-bsf=dump_extradata \
      --enable-bsf=extract_extradata \
      --enable-filter=anullsrc \
      --enable-filter=aresample \
      --enable-filter=anull \
      --enable-filter=aformat \
      --enable-filter=abuffer \
      --enable-filter=abuffersink \
      --extra-cflags="--sysroot=${SYSROOT}" \
      --extra-ldflags="--sysroot=${SYSROOT} -static" \
    && make -j$(nproc) \
    && ${CROSS_PREFIX}strip ffmpeg \
    && cp ffmpeg /opt/ffmpeg-bin

#-------------------------------------------------------------------------------
# Build ACAP application
#-------------------------------------------------------------------------------

WORKDIR /opt/app
COPY ./app .

# Bundle the cross-compiled FFmpeg binary
RUN cp /opt/ffmpeg-bin ./ffmpeg && chmod +x ./ffmpeg

ARG CHIP=

RUN . /opt/axis/acapsdk/environment-setup* && acap-build . \
	-a 'settings/settings.json' \
	-a 'settings/events.json' \
	-a 'ffmpeg'
