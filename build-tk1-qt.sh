#!/bin/bash


###
### Params
###
BASE_PATH=`pwd`

# Qt Version Params
QT_MAIN_VERSION="5.12"
QT_SUB_VERSION="6"
QT_FULL_VERSION=$QT_MAIN_VERSION.$QT_SUB_VERSION

# Qt Configure Params
FT_DEVICE=linux-jetson-tk1-g++
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
             -make libs -qt-xcb \
             -no-sql-mysql -no-sql-psql -no-sql-sqlite -nomake tests -nomake examples \
             2>&1 | tee configure.log

make -j8
make -j8 install

echo -e "#######################DONE##############################################\n"
echo ">>> Your qmake is ready on './output/qt/qt-everywhere-src-$QT_FULL_VERSION/aaaout/bin/qmake'"
echo -e "#######################DONE##############################################\n"
