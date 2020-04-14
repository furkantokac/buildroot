#!/bin/bash

# The script does not handle exceptions so its your responsibility to handle
# them according to your situation. Simply;
# - Don't run the script before building RPI3 image
# - Run it once. Then, handle it manually if it is required
#
# It is more handy for me to handle my own Qt out of Buildroot but I may
# implement this as Buildroot package in future with a proper kconfig
# implementation.


###
### Params
###
BASE_PATH=`pwd`

# Qt Version Params
QT_MAIN_VERSION="5.12"
QT_SUB_VERSION="1"
QT_FULL_VERSION=$QT_MAIN_VERSION.$QT_SUB_VERSION

# Qt Configure Params
FT_DEVICE=linux-rasp-pi3-g++
FT_SYSROOT=$BASE_PATH/output/host/usr/arm-buildroot-linux-gnueabihf/sysroot
FT_CROSS_COMPILE=$BASE_PATH/output/host/usr/bin/arm-buildroot-linux-gnueabihf-
FT_PREFIX=/usr/lib/qt5      # Prefix that will be for target device
FT_HOSTPREFIX=../aaaout/    # Compile to where on host device
FT_EXTPREFIX=$FT_HOSTPREFIX


###
### Fire up
###
mkdir output/qt
cd output/qt

wget https://download.qt.io/archive/qt/$QT_MAIN_VERSION/$QT_FULL_VERSION/single/qt-everywhere-src-$QT_FULL_VERSION.tar.xz
tar xJf qt-everywhere-src-$QT_FULL_VERSION.tar.xz
cd qt-everywhere-src-$QT_FULL_VERSION

mkdir aaabuild aaaout
cd aaabuild

../configure -release -static -opensource -confirm-license -v \
            -prefix $FT_PREFIX -hostprefix $FT_HOSTPREFIX -sysroot $FT_SYSROOT -extprefix $FT_EXTPREFIX \
            -device $FT_DEVICE -device-option CROSS_COMPILE=$FT_CROSS_COMPILE \
            -opengl es2 -make libs \
            -no-sql-mysql -no-sql-psql -no-sql-sqlite -no-xcb -nomake tests -nomake examples -no-use-gold-linker \
            2>&1 | tee configure.log


make -j8
make install -j8

echo -e "\n#######################DONE##############################################"
echo ">>> Your QMake is ready on './qt-everywhere-src-$QT_FULL_VERSION/aaaout/bin/qmake'"
echo -e "#######################DONE##############################################\n"
