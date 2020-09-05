#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate
# 获取luci-app-serverchan
#git clone https://github.com/tty228/luci-app-serverchan package/diy-packages/luci-app-serverchan
# 获取luci-app-adguardhome
#git clone https://github.com/rufengsuixing/luci-app-adguardhome package/diy-packages/luci-app-adguardhome
# 获取luci-app-openclash 编译po2lmo
#git clone -b master https://github.com/vernesong/OpenClash package/openclash
#pushd package/openclash/luci-app-openclash/tools/po2lmo
#make && sudo make install
#popd
#=================================================
# 清除默认主题
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
# Modify default theme
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
#=================================================
# 清除旧版argon主题并拉取最新版
pushd package/lean
rm -rf luci-theme-argon
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon luci-theme-argon
popd
#=================================================
# Add kernel build user
[ -z $(grep "CONFIG_KERNEL_BUILD_USER=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_USER="Ljzkirito"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_USER=\).*@\1$"Ljzkirito"@' .config

# Add kernel build domain
[ -z $(grep "CONFIG_KERNEL_BUILD_DOMAIN=" .config) ] &&
    echo 'CONFIG_KERNEL_BUILD_DOMAIN="GitHub Actions"' >>.config ||
    sed -i 's@\(CONFIG_KERNEL_BUILD_DOMAIN=\).*@\1$"GitHub Actions"@' .config
#=================================================
# Modify the version number
sed -i "s/OpenWrt /Ljzkirito build $(TZ=UTC-8 date "+%Y.%m.%d") @ OpenWrt /g" package/lean/default-settings/files/zzz-default-settings
#=================================================

cat >> package/lean/pdnsd-alt/patches/10-disallow-aaaa.patch <<eof
diff --git a/src/dns_answer.c b/src/dns_answer.c
index 6a2a5b5..5ded0f9 100644
--- a/src/dns_answer.c
+++ b/src/dns_answer.c
@@ -567,6 +567,7 @@ static int add_rrset(dns_msg_t **ans, size_t *sz, size_t *allocsz,
 		if (rnd_recs) b=first=randrr(crrset->rrs);

 		while (b) {
+			if (tp==T_AAAA) goto add_rrset_next;
 			if (!add_rr(ans, sz, allocsz, rrn, tp, ans_ttl(crrset,queryts),
 				    b->rdlen, b->data, S_ANSWER, udp, cb))
 				return 0;
@@ -584,6 +585,7 @@ static int add_rrset(dns_msg_t **ans, size_t *sz, size_t *allocsz,
 					break;
 				}
 			}
+add_rrset_next:
 			b=b->next;
 			if (rnd_recs) {
 				if(!b) b=crrset->rrs; /* wraparound */
eof

# Remove upx commands
#makefile_file="$({ find package|grep Makefile |sed "/Makefile./d"; } 2>"/dev/null")"
#for a in ${makefile_file}
#do
#	[ -n "$(grep "upx" "$a")" ] && sed -i "/upx/d" "$a"
#done
# Remove UnblockNeteaseMusicGo upx commands
sed -i "/upx/d" package/lean/UnblockNeteaseMusicGo/Makefile
exit 0
