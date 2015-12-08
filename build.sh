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

#Main
echo "Starting build..."
BUILD_START=$(date +"%s")
export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=/home/corphish/android/toolchains/gcc/4.8/bin/arm-eabi-
export KBUILD_BUILD_USER="avinaba"
export KBUILD_BUILD_HOST="build"
echo "Cleaning.."
if [ -f $KERNEL_DIR/arch/arm/boot/zImage ];
then
rm $ZIMAGE
fi
echo "Building..."
make cyanogenmod_taoshan_defconfig
make
if [ -f $ZIMAGE ];
then
echo "Copying kernel.."
cp $KERNEL_DIR/arch/arm/boot/$KERNEL $ZIP_DIR/tools/zImage
echo "Copying modules.."
rm $ZIP_DIR/system/lib/modules/*
find . -name '*.ko' -exec cp {} $ZIP_DIR/system/lib/modules \;
cd $ZIP_DIR/system/lib/modules
echo "Stripping modules for size.."
$STRIP --strip-unneeded *.ko
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo "Zipping.."
cd $KERNEL_DIR
./zip.sh
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
else
echo "Compilation failed! Fix the errors!"
fi


