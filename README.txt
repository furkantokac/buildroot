///
/// Description
///
This branch is specialized for Toradex TK1. TK1 board is added as external,
files are inside the br2-external-ftdev. You can use the build scripts on the
top directory for quick start.

Base Buildroot Version  : 2016.05
Nvidia Driver Version   : 21.5


///
/// Scripts
///
build-tk1-linux.sh  : Builds regular TK1 image.
build-tk1-qt.sh     : Builds static Qt. Run this after build TK1 image.


///
/// Notes
///
# uImage to zImage Issue
post-build.sh includes a command that convert zImage to uImage. 
-a : load address
-e : enty point
mkimage -A arm -O linux -T kernel -C none -a 0x10008000 -e 0x10008000 -n "Linux kernel" -d zImage uImage

Load address and entry point should be set correctly to be able to boot kernel
without any problem. You can find load address and entry point by checking logs
of your board when it is booting. (values should be written on the screen.


///
/// Packages Doc
///
Y : Required, Yes
N : Required, No

# OpenGL Qt App With XCB Backend
Y | BR2_PACKAGE_XORG7
Y | BR2_PACKAGE_XSERVER_XORG_SERVER
Y | BR2_PACKAGE_XSERVER_XORG_SERVER_AIGLX
Y | BR2_PACKAGE_LIBXKBCOMMON
Y | BR2_PACKAGE_MESA3D
Y | BR2_PACKAGE_MESA3D_DRI_DRIVER_SWRAST
Y | BR2_PACKAGE_MESA3D_OPENGL_ES
Y | BR2_PACKAGE_NVIDIA_DRIVERS

# CANbus, PIN
Y | BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_EUDEV
Y | BR2_PACKAGE_IPROUTE2
Y | ftdev-linux_defconfig

# Nvidia Drivers
Y | external.mk
Y | inflate-debpkg.sh
Y | install-versions.mk
Y | prebuilt-nested-package.mk
