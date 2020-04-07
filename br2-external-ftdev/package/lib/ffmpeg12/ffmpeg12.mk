################################################################################
#
# ffmpeg
#
################################################################################

FFMPEG12_VERSION = 1.2.12
FFMPEG12_SOURCE = ffmpeg-$(FFMPEG12_VERSION).tar.bz2
FFMPEG12_SITE = http://ffmpeg.org/releases
FFMPEG12_INSTALL_STAGING = YES

FFMPEG12_LICENSE = LGPLv2.1+, libjpeg license
FFMPEG12_LICENSE_FILES = LICENSE COPYING.LGPLv2.1
ifeq ($(BR2_PACKAGE_FFMPEG12_GPL),y)
FFMPEG12_LICENSE += and GPLv2+
FFMPEG12_LICENSE_FILES += COPYING.GPLv2
endif

FFMPEG12_CONF_OPTS = \
	--prefix=/usr		\
	--enable-avfilter \
	--disable-debug \
	--disable-version3 \
	--enable-logging \
	--disable-pic \
	--enable-optimizations \
	--disable-extra-warnings \
	--disable-ffprobe \
	--enable-avdevice \
	--enable-avcodec \
	--enable-avformat \
	--enable-swscale \
	--enable-postproc \
	--disable-x11grab \
	--enable-network \
	--disable-gray \
	--enable-swscale-alpha \
	--disable-small \
	--enable-dct \
	--enable-fft \
	--enable-mdct \
	--enable-rdft \
	--disable-crystalhd \
	--disable-vdpau \
	--disable-dxva2 \
	--enable-runtime-cpudetect \
	--disable-hardcoded-tables \
	--disable-memalign-hack \
	--enable-hwaccels \
	--disable-avisynth \
	--disable-frei0r \
	--disable-libopencore-amrnb \
	--disable-libopencore-amrwb \
	--disable-libopencv \
	--disable-libdc1394 \
	--disable-libfaac \
	--disable-libfreetype \
	--disable-libgsm \
	--disable-libmp3lame \
	--disable-libnut \
	--disable-libopenjpeg \
	--disable-librtmp \
	--disable-libschroedinger \
	--disable-libspeex \
	--disable-libtheora \
	--disable-libvo-aacenc \
	--disable-libvo-amrwbenc \
	--disable-vis \
	--disable-sram \
	--disable-symver \
	--disable-doc

FFMPEG12_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_FFMPEG12_GPL),y)
FFMPEG12_CONF_OPTS += --enable-gpl
else
FFMPEG12_CONF_OPTS += --disable-gpl
endif

ifeq ($(BR2_PACKAGE_FFMPEG12_NONFREE),y)
FFMPEG12_CONF_OPTS += --enable-nonfree
else
FFMPEG12_CONF_OPTS += --disable-nonfree
endif

ifeq ($(BR2_PACKAGE_FFMPEG12_FFMPEG),y)
FFMPEG12_CONF_OPTS += --enable-ffmpeg
else
FFMPEG12_CONF_OPTS += --disable-ffmpeg
endif

ifeq ($(BR2_PACKAGE_FFMPEG12_FFPLAY),y)
FFMPEG12_DEPENDENCIES += sdl
FFMPEG12_CONF_OPTS += --enable-ffplay
FFMPEG12_CONF_ENV += SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl-config
else
FFMPEG12_CONF_OPTS += --disable-ffplay
endif

ifeq ($(BR2_PACKAGE_FFMPEG12_FFSERVER),y)
FFMPEG12_CONF_OPTS += --enable-ffserver
else
FFMPEG12_CONF_OPTS += --disable-ffserver
endif

ifeq ($(BR2_PACKAGE_FFMPEG12_POSTPROC),y)
FFMPEG12_CONF_OPTS += --enable-postproc
else
FFMPEG12_CONF_OPTS += --disable-postproc
endif

ifeq ($(BR2_PACKAGE_FFMPEG12_SWSCALE),y)
FFMPEG12_CONF_OPTS += --enable-swscale
else
FFMPEG12_CONF_OPTS += --disable-swscale
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG12_ENCODERS)),all)
FFMPEG12_CONF_OPTS += --disable-encoders \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG12_ENCODERS)),--enable-encoder=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG12_DECODERS)),all)
FFMPEG12_CONF_OPTS += --disable-decoders \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG12_DECODERS)),--enable-decoder=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG12_MUXERS)),all)
FFMPEG12_CONF_OPTS += --disable-muxers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG12_MUXERS)),--enable-muxer=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG12_DEMUXERS)),all)
FFMPEG12_CONF_OPTS += --disable-demuxers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG12_DEMUXERS)),--enable-demuxer=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG12_PARSERS)),all)
FFMPEG12_CONF_OPTS += --disable-parsers \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG12_PARSERS)),--enable-parser=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG12_BSFS)),all)
FFMPEG12_CONF_OPTS += --disable-bsfs \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG12_BSFS)),--enable-bsfs=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG12_PROTOCOLS)),all)
FFMPEG12_CONF_OPTS += --disable-protocols \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG12_PROTOCOLS)),--enable-protocol=$(x))
endif

ifneq ($(call qstrip,$(BR2_PACKAGE_FFMPEG12_FILTERS)),all)
FFMPEG12_CONF_OPTS += --disable-filters \
	$(foreach x,$(call qstrip,$(BR2_PACKAGE_FFMPEG12_FILTERS)),--enable-filter=$(x))
endif

ifeq ($(BR2_PACKAGE_FFMPEG12_INDEVS),y)
FFMPEG12_CONF_OPTS += --enable-indevs
else
FFMPEG12_CONF_OPTS += --disable-indevs
endif

ifeq ($(BR2_PACKAGE_FFMPEG12_OUTDEVS),y)
FFMPEG12_CONF_OPTS += --enable-outdevs
else
FFMPEG12_CONF_OPTS += --disable-outdevs
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
FFMPEG12_CONF_OPTS += --enable-pthreads
else
FFMPEG12_CONF_OPTS += --disable-pthreads
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
FFMPEG12_CONF_OPTS += --enable-zlib
FFMPEG12_DEPENDENCIES += zlib
else
FFMPEG12_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
FFMPEG12_CONF_OPTS += --enable-bzlib
FFMPEG12_DEPENDENCIES += bzip2
else
FFMPEG12_CONF_OPTS += --disable-bzlib
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
# openssl isn't license compatible with GPL
ifeq ($(BR2_PACKAGE_FFMPEG12_GPL)x$(BR2_PACKAGE_FFMPEG12_NONFREE),yx)
FFMPEG12_CONF_OPTS += --disable-openssl
else
FFMPEG12_CONF_OPTS += --enable-openssl
FFMPEG12_DEPENDENCIES += openssl
endif
else
FFMPEG12_CONF_OPTS += --disable-openssl
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
FFMPEG12_DEPENDENCIES += libvorbis
FFMPEG12_CONF_OPTS += \
	--enable-libvorbis \
	--enable-muxer=ogg \
	--enable-encoder=libvorbis
endif

ifeq ($(BR2_PACKAGE_LIBVA),y)
FFMPEG12_CONF_OPTS += --enable-vaapi
FFMPEG12_DEPENDENCIES += libva
else
FFMPEG12_CONF_OPTS += --disable-vaapi
endif

ifeq ($(BR2_X86_CPU_HAS_MMX),y)
FFMPEG12_CONF_OPTS += --enable-yasm
FFMPEG12_DEPENDENCIES += host-yasm
else
FFMPEG12_CONF_OPTS += --disable-yasm
FFMPEG12_CONF_OPTS += --disable-mmx
endif

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
FFMPEG12_CONF_OPTS += --enable-sse
else
FFMPEG12_CONF_OPTS += --disable-sse
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
FFMPEG12_CONF_OPTS += --enable-sse2
else
FFMPEG12_CONF_OPTS += --disable-sse2
endif

ifeq ($(BR2_X86_CPU_HAS_SSE3),y)
FFMPEG12_CONF_OPTS += --enable-sse3
else
FFMPEG12_CONF_OPTS += --disable-sse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSSE3),y)
FFMPEG12_CONF_OPTS += --enable-ssse3
else
FFMPEG12_CONF_OPTS += --disable-ssse3
endif

ifeq ($(BR2_X86_CPU_HAS_SSE4),y)
FFMPEG12_CONF_OPTS += --enable-sse4
else
FFMPEG12_CONF_OPTS += --disable-sse4
endif

ifeq ($(BR2_X86_CPU_HAS_SSE42),y)
FFMPEG12_CONF_OPTS += --enable-sse42
else
FFMPEG12_CONF_OPTS += --disable-sse42
endif

# Explicitly disable everything that doesn't match for ARM
# FFMPEG12 "autodetects" by compiling an extended instruction via AS
# This works on compilers that aren't built for generic by default
ifeq ($(BR2_arm920t)$(BR2_arm922t)$(BR2_strongarm)$(BR2_fa526),y)
FFMPEG12_CONF_OPTS += --disable-armv5te
endif
ifeq ($(BR2_arm1136jf_s)$(BR2_arm1176jz_s)$(BR2_arm1176jzf_s),y)
FFMPEG12_CONF_OPTS += --enable-armv6
else
FFMPEG12_CONF_OPTS += --disable-armv6 --disable-armv6t2
endif
ifeq ($(BR2_arm10)$(BR2_arm1136jf_s)$(BR2_arm1176jz_s)$(BR2_arm1176jzf_s)$(BR2_cortex_a5)$(BR2_cortex_a8)$(BR2_cortex_a9)$(BR2_cortex_a15),y)
FFMPEG12_CONF_OPTS += --enable-vfp
else
FFMPEG12_CONF_OPTS += --disable-vfp
endif
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
FFMPEG12_CONF_OPTS += --enable-neon
endif

ifeq ($(BR2_MIPS_SOFT_FLOAT),y)
FFMPEG12_CONF_OPTS += \
	--disable-mipsfpu
else
FFMPEG12_CONF_OPTS += \
	--enable-mipsfpu
endif

ifeq ($(BR2_mips_32r2),y)
FFMPEG12_CONF_OPTS += \
	--enable-mips32r2
else
FFMPEG12_CONF_OPTS += \
	--disable-mips32r2
endif

ifeq ($(BR2_mips_64r2),y)
FFMPEG12_CONF_OPTS += \
	--enable-mipsdspr1 \
	--enable-mipsdspr2
else
FFMPEG12_CONF_OPTS += \
	--disable-mipsdspr1 \
	--disable-mipsdspr2
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),y)
FFMPEG12_CONF_OPTS += --enable-altivec
else
FFMPEG12_CONF_OPTS += --disable-altivec
endif

ifeq ($(BR2_PREFER_STATIC_LIB),)
FFMPEG12_CONF_OPTS += --enable-pic
endif

FFMPEG12_CONF_OPTS += $(call qstrip,$(BR2_PACKAGE_FFMPEG12_EXTRACONF))

# Override FFMPEG12_CONFIGURE_CMDS: FFmpeg does not support --target and others
define FFMPEG12_CONFIGURE_CMDS
	(cd $(FFMPEG12_SRCDIR) && rm -rf config.cache && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	$(FFMPEG12_CONF_ENV) \
	./configure \
		--enable-cross-compile	\
		--cross-prefix=$(TARGET_CROSS) \
		--sysroot=$(STAGING_DIR) \
		--host-cc="$(HOSTCC)" \
		--arch=$(BR2_ARCH) \
		--target-os="linux" \
		$(if $(BR2_GCC_TARGET_TUNE),--cpu=$(BR2_GCC_TARGET_TUNE)) \
		$(SHARED_STATIC_LIBS_OPTS) \
		$(FFMPEG12_CONF_OPTS) \
	)
endef

$(eval $(autotools-package))
