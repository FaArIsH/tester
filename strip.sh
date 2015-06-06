STRIP="/home/corphish/android/toolchain/linaro-4.9.3-arm-cortex-a15/bin/arm-eabi-strip"

cd zip/system/lib/modules
echo "Stripping modules for size"
$STRIP --strip-unneeded *.ko
