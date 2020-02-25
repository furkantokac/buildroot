Purpose of this board is monitoring data coming from UART with an application written in
Qt, in the fastest-booted way so it is specialized for Qt, UART and Fast Boot. HDMI screen is
used as dispay.

Qt application is compiled statically so system is not required to include Qt packages. Also
it is not required to include busybox since application already does required things that
busybox does. This is done for faster booting.

# Supported
For the fastest booting, apply kernel settings at
board/ftdev/rpi3/docs/distro_optimization/fcond04/README.config

There are 3 defconfigs for this board;
1 ftdev_rpi3_minimal_defconfig  : Ready to add Qt packages but not added so you can configure Qt by "make xconfig" according to your application's needs.
2 ftdev_rpi3_qt_defconfig       : Qt packages are added. This can run QML application and get data from UART.
3 ftdev_rpi3_fastboot_defconfig : System be booted in 1.2seconds. You can put your statically-compiled Qt application in it so it'll directly run.

For various recommended kernel configuration, please see the board/doc/README.txt
As default, kernel configurations are not applied to defconfigs


###
### Folder "kernel_patches"
###
Put your kernel patches into the {kernel_patches} folder and it'll automatically be 
applied to the output.


###
### Folder "rootfs_overlay"
###
Add the files that you wanted to be included in the final image.


###
### Folder "custom_files"
###
That files will be used while creating output/images/custom image.
If you want to use UART, custom_files/cmdline.txt is important for you.

###
### Changing boot image
###
0 Apply "kernel_patches/bootlogo.patch" patch to you kernel.
1 Put the image that you want to custom_files folder.
2 Convert your image to ppm by using board/ftdev/rpi3/custom_files/convert-to-ppm.sh script.
3 Enter "make linux-xconfig" command and close the opened window.
4 Run board/ftdev/rpi3/custom_files/change-linux-boot-image.sh script.
5 Enter "make linux-rebuild" command.
6 Enter "make" command.
7 Done.
