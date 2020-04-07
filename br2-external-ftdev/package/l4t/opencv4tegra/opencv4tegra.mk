# URLs extracted from JetPack v2.2.1
OPENCV4TEGRA_VERSION = 2.4.13
OPENCV4TEGRA_SITE = http://developer.download.nvidia.com/devzone/devcenter/mobile/jetpack_l4t/003/linux-x64
OPENCV4TEGRA_SOURCE = libopencv4tegra-repo_$(OPENCV4TEGRA_VERSION)_armhf_l4t-r21.deb
OPENCV4TEGRA_LICENSE = EULA
OPENCV4TEGRA_LICENSE_FILES = ./usr/share/doc/libopencv4tegra-repo/copyright
OPENCV4TEGRA_REDISTRIBUTE = NO
OPENCV4TEGRA_DEPENDENCIES = cuda libpng12 jpeg tiff jasper ffmpeg12 \
			    libgtk2 zlib libtbb

OPENCV4TEGRA_INSTALL_TARGET = YES
OPENCV4TEGRA_INSTALL_STAGING = YES

OPENCV4TEGRA_INNER_SRC_PREFIX = ./var/libopencv4tegra-repo/
OPENCV4TEGRA_OUTER_SRC_EXTRACT_EXTRA = $(OPENCV4TEGRA_LICENSE_FILES)

opencv4tegra-debfiles = $(addsuffix _$(OPENCV4TEGRA_VERSION)_armhf.deb,$(1))
OPENCV4TEGRA_INNER_SRC_FOR_TARGET = $(call opencv4tegra-debfiles, \
	libopencv4tegra \
)
OPENCV4TEGRA_INNER_SRC_FOR_STAGING = $(call opencv4tegra-debfiles, \
	libopencv4tegra \
	libopencv4tegra-dev \
)

$(eval $(prebuilt-nested-package))
