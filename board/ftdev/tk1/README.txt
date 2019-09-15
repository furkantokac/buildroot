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
Ready to add Qt packages but not added so you can configure Qt by "make xconfig" according to your application's needs.


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
# Alpha 0.5 (Current)
Supported Features;
- Linux Kernel
- Rootfs

Coming Features;
- Uboot
- Generating suitable image to easily flash to Toradex Apalis TK1
