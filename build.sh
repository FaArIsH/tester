 #
 # Copyright � 2014, Varun Chitre "varun.chitre15" <varun.chitre15@gmail.com>
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 #
#!/bin/bash
#Tuneables
STRIP="/home/corphish/android/toolchains/linaro/linaro-4.9.4/bin/arm-eabi-strip"
ZIMAGE="/home/corphish/android/kernel/taoshan/5.1/arch/arm/boot/zImage"
KERNEL_DIR="/home/corphish/android/kernel/taoshan/5.1"
ZIP_DIR="/home/corphish/android/kernel/taoshan/5.1/zip/raw"
KERNEL="zImage"
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
green='\033[0;32m'
nocol='\033[0m'

#Main
echo -e "$blue Starting build...$nocol"
BUILD_START=$(date +"%s")
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=/home/corphish/android/toolchains/linaro/linaro-4.9.4/bin/arm-eabi-
export KBUILD_BUILD_USER="avinaba"
export KBUILD_BUILD_HOST="build"
echo -e "$yellow Cleaning..$nocol"
if [ -a $KERNEL_DIR/arch/arm/boot/zImage ];
then
rm $ZIMAGE
fi
echo -e "$yellow Building..$nocol"
make cyanogenmod_taoshan_defconfig
make
if [ -a $ZIMAGE ];
then
echo -e "$cyan Copying kernel..$nocol"
cp $KERNEL_DIR/arch/arm/boot/$KERNEL $ZIP_DIR/tools/zImage
echo -e "$cyan Copying modules..$nocol"
rm ZIP_DIR/system/lib/modules/*
find . -name '*.ko' -exec cp {} $ZIP_DIR/system/lib/modules \;
cd $ZIP_DIR/system/lib/modules
echo -e "$yellow Stripping modules for size..$nocol"
$STRIP --strip-unneeded *.ko
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Zipping..$nocol"
cd $KERNEL_DIR
./zip.sh
echo -e "$green Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
else
echo -e "$red Compilation failed! Fix the errors!$nocol"
fi


