#!/bin/bash

# Set-up ccache
if [ -z "$CCACHE_SIZE" ]; then
    ccache -M 10G
else
    ccache -M ${CCACHE_SIZE}
fi

sudo apt update -y

sudo apt install bc -y

sudo ln -s /lib/x86_64-linux-gnu/libreadline.so.7 /lib/x86_64-linux-gnu/libreadline.so.8

# set configs.
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# Create dirs
mkdir carbon ; cd carbon

# Init repo
repo init --depth=1 --no-repo-verify -u https://github.com/CarbonROM/android.git -b cr-8.0 -g default,-mips,-darwin,-notdefault

# Clone my local repo
git clone https://github.com/youssefnoner/android_manifest_samsung_m10lte.git -b cr-8.0 .repo/local_manifests

# Sync
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# Build
. build/envsetup.sh && lunch carbon_m10lte-eng && mka carbon -j`nproc`

exit 0
