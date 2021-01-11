#!/bin/bash

# 修正内核
git clone --depth 1 -b 19.07 https://github.com/Lienol/openwrt.git Lienol
rm -rf target/linux/generic
mv Lienol/target/linux/generic target/linux/

# Ofast
sed -i "s/-O[0-9a-zA-Z]\+ /-Ofast /" include/target.mk
sed -i "s/-O[0-9a-zA-Z]\+ /-Ofast /" ./rules.mk

# only build k3
sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3|' target/linux/bcm53xx/image/Makefile

# 更新自定义配置
mkdir -p package/MJ/default-settings
mv ../server/default-settings/* package/MJ/default-settings
sed -i 's/DISTRIB_REVISION=.*'"'"'/DISTRIB_REVISION='"'R$(TZ=UTC-8 date +"%m.%d")'"'/' package/MJ/default-settings/files/zzz-default-settings

# 修改系统欢迎词
mv ../server/etc/banner package/base-files/files/etc/banner

# 增加ll命令
sed -i '/PATH/i\alias ll="ls -alF --color=auto"\n' package/base-files/files/etc/profile



# k3 proprietary wifi driver
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/k3-brcmfmac4366c-firmware package/MJ/k3wifi
mv ../server/file_config/brcmfmac4366c-pcie.bin package/MJ/k3wifi/files/lib/firmware/brcm
mv ../server/file_config/mac80211.sh package/kernel/mac80211/files/lib/wifi
sed -i 's|$(IEEE8021X) kmod-brcmfmac brcmfmac-firmware-4366c0-pcie|$(IEEE8021X) kmod-brcmfmac k3wifi|g' target/linux/bcm53xx/image/Makefile

# 更新smartdns
svn co https://github.com/1005789164/openwrt-smartdns/trunk/smartdns package/MJ/smartdns
svn co https://github.com/1005789164/openwrt-smartdns/trunk/luci-app-smartdns package/MJ/luci-app-smartdns

# 添加新屏幕
git clone --depth 1 https://github.com/1005789164/luci-app-k3screenctrl.git package/MJ/luci-app-k3screenctrl
git clone --depth 1 https://github.com/1005789164/k3screenctrl_build.git package/MJ/k3screenctrl_build

# k3usb
svn co https://github.com/project-openwrt/openwrt/branches/master/package/zxlhhyccc/luci-app-k3usb/ package/MJ/luci-app-k3usb
sed -i 's/LUCI_DEPENDS:=.*/LUCI_DEPENDS:=/' package/MJ/luci-app-k3usb/Makefile

# 增加 luci-theme-argon
git clone --depth 1 https://github.com/jerrykuku/luci-theme-argon.git package/MJ/luci-theme-argon

# uhttpd
rm -rf feeds/luci/applications/luci-app-uhttpd
svn co https://github.com/openwrt/luci/trunk/applications/luci-app-uhttpd feeds/luci/applications/luci-app-uhttpd

# OpenAppFilter
git clone --depth 1 https://github.com/destan19/OpenAppFilter.git package/MJ/OpenAppFilter

# access control
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-accesscontrol package/MJ/luci-app-accesscontrol

# advancedsetting
svn co https://github.com/project-openwrt/openwrt/branches/master/package/ntlf9t/luci-app-advancedsetting/ package/MJ/luci-app-advancedsetting

# 复杂的AdGuardHome的openwrt的luci界面
git clone --depth 1 https://github.com/rufengsuixing/luci-app-adguardhome.git package/MJ/luci-app-adguardhome
mv ../server/etc/AdGuardHome_template.yaml package/MJ/luci-app-adguardhome/root/usr/share/AdGuardHome/

#mkdir -p package/MJ/luci-app-adguardhome/root/usr/bin/AdGuardHome
#pushd package/MJ/luci-app-adguardhome/root/usr/bin/AdGuardHome
#curl -fsSL https://static.adguard.com/adguardhome/release/AdGuardHome_linux_armv5.tar.gz > AdGuardHome.tar.gz
#tar zxvf AdGuardHome.tar.gz
#mv AdGuardHome AdGuardHome_dir && mv AdGuardHome_dir/AdGuardHome AdGuardHome
#chmod +x AdGuardHome
#rm -rf AdGuardHome.tar.gz AdGuardHome_dir
#popd

# AutoCore
svn co https://github.com/project-openwrt/openwrt/branches/master/package/lean/autocore package/MJ/autocore

# automount
rm -rf ./feeds/packages/kernel/exfat-nofuse
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/automount package/MJ/automount
svn co https://github.com/openwrt/packages/trunk/utils/antfs-mount package/utils/antfs-mount
svn co https://github.com/openwrt/packages/trunk/kernel/antfs package/kernel/antfs
svn co https://github.com/openwrt/openwrt/trunk/package/kernel/exfat package/kernel/exfat

# autosamba
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/autosamba package/MJ/autosamba

# arpbind
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-arpbind package/MJ/luci-app-arpbind

# ramfree
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-ramfree package/MJ/luci-app-ramfree

# adbyby-plus
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-adbyby-plus package/MJ/luci-app-adbyby-plus
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/adbyby package/MJ/adbyby

# koolproxyR
git clone --depth 1 https://github.com/project-openwrt/luci-app-koolproxyR.git package/MJ/luci-app-koolproxyR

# mwan3helper
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-mwan3helper package/MJ/luci-app-mwan3helper

# OpenClash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash/ package/MJ/luci-app-openclash

# 下载Lienol软件包
git clone --depth 1 https://github.com/Lienol/openwrt-package.git openwrt-package
# fileassistant
mv openwrt-package/luci-app-fileassistant/ package/MJ/luci-app-fileassistant
# filebrowser
mv openwrt-package/luci-app-filebrowser/ package/MJ/luci-app-filebrowser
# control-timewol
mv openwrt-package/luci-app-control-timewol/ package/MJ/luci-app-control-timewol
# control-webrestriction
mv openwrt-package/luci-app-control-webrestriction/ package/MJ/luci-app-control-webrestriction
# control-weburl
mv openwrt-package/luci-app-control-weburl/ package/MJ/luci-app-control-weburl
# syncthing
mv openwrt-package/luci-app-syncthing/ package/MJ/luci-app-syncthing
# vpnserver
mv openwrt-package/luci-app-pptp-server/ package/MJ/luci-app-pptp-server
# softethervpn
mv openwrt-package/luci-app-softethervpn/ package/MJ/luci-app-softethervpn
# 删除下载的Lienol软件包
rm -rf openwrt-package

# aria2
#rm -rf ./feeds/packages/net/aria2 ariang webui-aria2
#rm -rf ./feeds/luci/applications/luci-app-aria2
#svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-aria2/ feeds/luci/applications/luci-app-aria2
#svn co https://github.com/coolsnowwolf/packages/trunk/net/aria2/ feeds/packages/net/aria2
#svn co https://github.com/coolsnowwolf/packages/trunk/net/ariang/ feeds/packages/net/ariang
#svn co https://github.com/coolsnowwolf/packages/trunk/net/webui-aria2/ feeds/packages/net/webui-aria2


# DDNS
rm -rf ./feeds/packages/net/ddns-scripts
rm -rf ./feeds/luci/applications/luci-app-ddns
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_aliyun package/MJ/ddns-scripts_aliyun
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ddns-scripts_dnspod package/MJ/ddns-scripts_dnspod
svn co https://github.com/openwrt/packages/trunk/net/ddns-scripts feeds/packages/net/ddns-scripts
svn co https://github.com/openwrt/luci/trunk/applications/luci-app-ddns feeds/luci/applications/luci-app-ddns
rm -rf ./feeds/packages/libs/giflib
svn co https://github.com/openwrt/packages/trunk/libs/giflib feeds/packages/libs/giflib

# Filetransfer
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-filetransfer package/MJ/luci-app-filetransfer
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-lib-fs package/MJ/luci-lib-fs

# frp
rm -f ./feeds/luci/applications/luci-app-frps
rm -f ./feeds/luci/applications/luci-app-frpc
rm -rf ./feeds/packages/net/frp
rm -rf ./package/feeds/packages/frp
#git clone --depth 1 --single-branch https://github.com/kuoruan/luci-app-frpc.git package/MJ/luci-app-frpc
#git clone --depth 1 --single-branch https://github.com/lwz322/luci-app-frps.git package/MJ/luci-app-frps
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/frp package/MJ/frp
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-frpc package/MJ/luci-app-frpc
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-frps package/MJ/luci-app-frps

# IPSEC
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-ipsec-vpnd package/MJ/luci-app-ipsec-vpnd

# Zerotier
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-zerotier package/MJ/luci-app-zerotier


# PassWall
rm -rf ./feeds/packages/net/kcptun
rm -rf ./feeds/packages/net/shadowsocks-libev
git clone --depth 1 https://github.com/xiaorouji/openwrt-passwall.git package/MJ/openwrt-passwall
rm -rf package/MJ/openwrt-passwall/chinadns-ng
svn co https://github.com/1005789164/openwrt-chinadns-ng/trunk/chinadns-ng package/MJ/chinadns-ng
svn co https://github.com/1005789164/openwrt-chinadns-ng/trunk/luci-app-chinadns-ng package/MJ/luci-app-chinadns-ng
svn co https://github.com/coolsnowwolf/packages/trunk/net/shadowsocks-libev package/MJ/shadowsocks-libev
pushd feeds/packages/lang
rm -fr golang
svn co https://github.com/coolsnowwolf/packages/trunk/lang/golang
popd

# 增加 ucl upx
mv Lienol/tools/ucl tools/
mv Lienol/tools/upx tools/
sed -i '/CONFIG_TARGET_tegra/a\tools-y += ucl upx' tools/Makefile
sed -i '/dependencies/a\$(curdir)/upx/compile := $(curdir)/ucl/compile' tools/Makefile

# FullCone
mv Lienol/package/network/fullconenat package/network/
mkdir -p package/network/config/firewall/patches
wget -P package/network/config/firewall/patches/ https://raw.githubusercontent.com/Lienol/openwrt/19.07/package/network/config/firewall/patches/fullconenat.patch


# Scheduled Reboot
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-autoreboot package/MJ/luci-app-autoreboot

# Unblock Netease Music
git clone --depth 1 --single-branch https://github.com/cnsilvan/luci-app-unblockneteasemusic.git package/MJ/luci-app-unblockneteasemusic-go

# UPNP
rm -rf ./feeds/packages/net/miniupnpd
svn co https://github.com/coolsnowwolf/packages/trunk/net/miniupnpd feeds/packages/net/miniupnpd

# USB Printer
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-usb-printer package/MJ/luci-app-usb-printer

# vlmcsd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/vlmcsd package/MJ/vlmcsd
svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/luci-app-vlmcsd package/MJ/luci-app-vlmcsd

# zram-swap
rm -rf package/system/zram-swap
svn co https://github.com/openwrt/openwrt/trunk/package/system/zram-swap package/system/zram-swap


rm -rf Lienol
exit 0
