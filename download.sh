#!/bin/bash

sudo apt update -y && sudo apt install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc libncurses5 unzip python -y && mkdir ~/bin && curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo && chmod a+x ~/bin/repo && sudo ln -sf ~/bin/repo /usr/bin/repo && git config --global user.email "you@example.com" && git config --global user.name "Your Name" && mkdir crdroid && cd crdroid && repo init --depth=1 -u https://github.com/crdroidandroid/android.git -b 10.0 && repo sync --no-repo-verify -c --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune -j`nproc` && rm -rf .repo && git clone --depth=1 https://github.com/youssefnone/android_kernel_samsung_exynos7870 kernel/samsung/exynos7870 && git clone --depth=1 https://github.com/youssefnone/android_device_samsung_universal7870-common device/samsung/universal7870-common && git clone --depth=1 https://github.com/youssefnone/android_vendor_samsung_universal7870-common vendor/samsung/universal7870-common && git clone --depth=1 https://github.com/youssefnone/android_device_samsung_m10lte device/samsung/m10lte && git clone --depth=1 https://github.com/youssefnone/android_vendor_samsung_m10lte vendor/samsung/m10lte && git clone --depth=1 https://github.com/samsungexynos7870/android_hardware_samsung -b lineage-17.1 hardware/samsung && . build/envsetup.sh && lunch lineage_m10lte-eng && mka clean
mka vendorimage -j`nproc`

TIMEOUT=20160
cd ~/rom
ls out/target/product/m10lte
zip lineage.zip out/target/product/m10lte/vendor.img
export OUTPUT="vendor.img"
FILENAME=$(echo $OUTPUT)

# Upload to WeTransfer
# NOTE: the current Docker Image, "registry.gitlab.com/sushrut1101/docker:latest", includes the 'transfer' binary by Default
transfer wet $FILENAME > link.txt || { echo "ERROR: Failed to Upload the Build!" && exit 1; }

# Mirror to oshi.at
curl -T $FILENAME https://oshi.at/${FILENAME}/${OUTPUT} > mirror.txt || { echo "WARNING: Failed to Mirror the Build!"; }

DL_LINK=$(cat link.txt | grep Download | cut -d\  -f3)
MIRROR_LINK=$(cat mirror.txt | grep Download | cut -d\  -f1)

# Show the Download Link
echo "=============================================="
echo "Download Link: ${DL_LINK}" || { echo "ERROR: Failed to Upload the Build!"; }
echo "Mirror: ${MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "=============================================="

exit 0
