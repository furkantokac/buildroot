# ftDev Buildroot Repository

## Description

This branch is specialized for Raspberry Pi 3 for now.

Base Buildroot Version  : 2019.02.5


## Scripts

build-rpi3-qt.sh     : Builds static Qt. Run this after build RPI3 image.


## Quick Start

### Build RPI3 fastboot distro + static Qt

1. make ftdev_rpi3_fastboot_defconfig
2. make -j8
3. ./build-rpi3-qt.sh

**RPI3 Image** : output/images/sdcard.img
**qmake** : output/qt/qt-everywhere-src-*/aaaout/bin/qmake
