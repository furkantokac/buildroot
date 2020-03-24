///
/// THIS FILE WILL BE RENEWED
///


/// 
/// ftDev Apalis TK1 Toradex.
///
Toradex's Apalis TK1 board.


///
/// Purposes
///
- Running safety-critial application
- Running Qt, QtQuick, Qt3D application
- Fast boot to Qt application
- No network support


///
/// Defconfigs
///
# ftdev_tk1_minimal_defconfig
You can run statically compiled Qt application on tk1_minimal.


///
/// Important Notes
///
# uImage to zImage Issue
post-build.sh includes a command that convert zImage to uImage. 
-a : load address
-e : enty point
mkimage -A arm -O linux -T kernel -C none -a 0x10008000 -e 0x10008000 -n "Linux kernel" -d zImage uImage

Load address and entry point should be set correctly to be able to boot kernel without any problem. You can find load address and entry point by checking logs of your board when it is booting. (values should be written on the screen.

# Usage
make ftdev_tk1_defconfig # Choose defconfig from Defconfigs section.
make 2>&1 | tee build.log


///
/// Version Notes
///
# Alpha 0.6 (Current)
Supported Features;
- Linux Kernel
- Rootfs

Coming Features;
- Uboot
- Generating suitable image to easily flash to Toradex Apalis TK1


# Alpha 0.5
Supported Features;
- Linux Kernel
- Rootfs

Coming Features;
- Uboot
- Generating suitable image to easily flash to Toradex Apalis TK1


///
/// Docs
///
Y : Required, Yes
O : Required, Not sure
N : Required, No

Y | BR2_PACKAGE_XORG7 -------------------------\
Y | BR2_PACKAGE_XSERVER_XORG_SERVER ------------\
Y | BR2_PACKAGE_XSERVER_XORG_SERVER_AIGLX -------\
Y | BR2_PACKAGE_LIBXKBCOMMON ---------------------\
Y | BR2_PACKAGE_MESA3D ---------------------------/ Qt App
Y | BR2_PACKAGE_MESA3D_DRI_DRIVER_SWRAST --------/
Y | BR2_PACKAGE_MESA3D_OPENGL_ES ---------------/
Y | BR2_PACKAGE_NVIDIA_DRIVERS ----------------/
Y | BR2_ROOTFS_DEVICE_CREATION_DYNAMIC_EUDEV --\ CAN, PINS
Y | BR2_PACKAGE_IPROUTE2 ----------------------/
Y | ftdev-linux_defconfig --------------------/
Y | external.mk : nvidia sürücüleri için lazım. inflate-debpkg.sh install-versions.mk prebuilt-nested-package.mk
