#!/bin/bash

# setup color
red='\033[0;31m'
green='\e[0;32m'
white='\033[0m'
yellow='\033[0;33m'

WORK_DIR=$(pwd)
KERN_IMG="${WORK_DIR}/out/arch/arm64/boot/Image-gz.dtb"
KERN_IMG2="${WORK_DIR}/out/arch/arm64/boot/Image.gz"

function build_kernel() {
    # Start timer
    START_TIME=$(date +%s)

    echo -e "\n"
    echo -e "$yellow << building kernel >> \n$white"
    echo -e "\n"
    
    rm -rf out

    make -j7 O=out ARCH=arm64 rolex_defconfig
    make -j7 ARCH=arm64 O=out \
                          CROSS_COMPILE=aarch64-linux-gnu- \
                          CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
                          CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
                          
    # End timer
    END_TIME=$(date +%s)
    BUILD_TIME=$(( END_TIME - START_TIME ))

    if [ -e "$KERN_IMG" ] || [ -e "$KERN_IMG2" ]; then
        echo -e "\n"
        echo -e "$green << compile kernel success! >> \n$white"
    else
        echo -e "\n"
        echo -e "$red << compile kernel failed! >> \n$white"
    fi

    # Convert seconds → minutes + seconds
    MIN=$(( BUILD_TIME / 60 ))
    SEC=$(( BUILD_TIME % 60 ))

    echo -e "$yellow Waktu build: ${MIN} menit ${SEC} detik $white\n"
}

# execute
build_kernel
