#!/bin/bash

FT_DEFCONFIG=ftdev_tk1_defconfig
#FT_DEFCONFIG=ftdev_tk1_minimal_defconfig

cp -r ./br2-external-ftdev/patches/br16.05/gcc/4.9.3/* ./package/gcc/4.9.3/
BR2_EXTERNAL=./br2-external-ftdev make $FT_DEFCONFIG
BR2_EXTERNAL=./br2-external-ftdev make -j8 2>&1 | tee build.log


echo -e "#######################DONE##############################################"
echo ">>> Your system is ready on './output/images/'"
echo ">>> You can use './output/images/update.sh' to flash your device."
echo ">>> Enter 'update.sh -h' command to see the usage of the script."
echo -e "#######################DONE##############################################\n"
