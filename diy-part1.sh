#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
#sed -i '$a src-git helloworld https://github.com/Ljzkirito/helloworld' feeds.conf.default

#wget https://github.com/coolsnowwolf/lede/commit/aaa5a16a2b77122978bdfa64d86f6dbce2c7c32d.patch
#git apply aaa5a16a2b77122978bdfa64d86f6dbce2c7c32d.patch

#wget https://github.com/AmadeusGhost/lede/commit/34d9c51bbb9828f5eaeb9730e8c19e0b898e048b.patch
#git apply 34d9c51bbb9828f5eaeb9730e8c19e0b898e048b.patch
