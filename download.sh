#!/bin/bash

# install package.
sudo apt update -y
sudo apt install libreadline7 git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc libncurses5 unzip python -y
# run repo.

mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
sudo ln -sf ~/bin/repo /usr/bin/repo

wget http://mirrors.kernel.org/ubuntu/pool/main/r/readline/libreadline7_7.0-3_amd64.deb -O a.deb
sudo dpkg -i a.deb

wget http://mirrors.kernel.org/ubuntu/pool/main/b/bc/bc_1.07.1-2_amd64.deb -O h.deb
sudo dpkg -i h.deb

wget http://mirrors.kernel.org/ubuntu/pool/main/p/popt/libpopt0_1.16-11_amd64.deb -O l.deb
sudo dpkg -i l.deb

wget http://security.ubuntu.com/ubuntu/pool/main/r/rsync/rsync_3.1.2-2.1ubuntu1.5_amd64.deb -O i.deb
sudo dpkg -i i.deb

# Set-up ccache
if [ -z "$CCACHE_SIZE" ]; then
    ccache -M 10G
else
    ccache -M ${CCACHE_SIZE}
fi

sudo apt install bc libreadline7 -y

# set configs.
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# Create dirs
mkdir carbon ; cd carbon

# Init repo
repo init --depth=1 -u https://github.com/CarbonROM/android.git -b cr-8.0

# Clone my local repo
git clone https://github.com/youssefnoner/android_manifest_samsung_m10lte.git -b cr-8.0 .repo/local_manifests

# Sync
repo sync --no-repo-verify -c --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune -j`nproc`
repo sync -j1 --fail-fast

# Build
. build/envsetup.sh && lunch carbon_m10lte-eng && mka clean && mka carbon -j`nproc`

exit 0
