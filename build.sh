#!/bin/bash

# Defaults
ARCH=arm
DEFCONFIG=cyanogenmod_taoshan_defconfig
DEVICE=taoshan
LOCAL_PATH=$(pwd)
KERNEL=zImage
KERNEL_PATH=$LOCAL_PATH/arch/arm/boot/$KERNEL
ZIP_DIR=$LOCAL_PATH/zip/raw

# Tuneables
CROSS_COMPILE_LOCATION=/home/boo/android/system/cm-13.0/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8
CROSS_COMPILE=$CROSS_COMPILE_LOCATION/bin/arm-eabi-
STRIP=$CROSS_COMPILE_LOCATION/bin/arm-eabi-strip
ZIP_PREFIX=zd

# Colors
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

warn() {
	echo -e $yellow"Warning:"$nocol $@
}

error() {
	echo -e $red"Error:"$nocol $@
}

info() {
	echo -e $blue"Info:"$nocol $@
}

install() {
	echo -e $cyan"Install:"$nocol $@
}

export_variables() {
	export ARCH=$ARCH
	export CROSS_COMPILE=$CROSS_COMPILE
}

check_environment() {
	if [ -f $KERMEL_PATH ];
	then
		warn "You are making a dirty build"
	else
		info "Making a clean build"
	fi
	if [ -d $ZIP_DIR ];
	then
		info "Template zip directory found, proceeding..."
	else
		error "Template zip directory not found. Aborting!!"
		exit
	fi	
}

clean() {
	make clean
	rm -rf .version
}

build_kernel() {
	make $DEFCONFIG
	make
}

make_zip() {
	# TODO: Better do python and use the technique used by Android build system.
	cd $ZIP_DIR
	zip -r ../archives/$ZIP_PREFIX-$(date +"%Y%m%d")-$DEVICE.zip *
}

wrapper() {
	if [ "$1" == "clean" ];
	then info "Cleaning" && clean
	fi
	check_environment
	export_variables
	info "Building kernel.."
	build_kernel
	if [ ! -f $KERNEL_PATH ];
	then error "Build failed! Please fix the errors!" && exit
	fi
	info "Making flashable zip"
	make_zip
	install $LOCAL_PATH/zip/archives/$ZIP_PREFIX-$(date +"%Y%m%d")-$DEVICE.zip
}

wrapper $1
