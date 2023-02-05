#!/bin/bash

LUCI_DIR='package/mj'
PACK_DIR='package/mj'
FEEDS_LUCI='package/feeds/luci'
FEEDS_PCK='package/feeds/packages'
ln -s ../feeds/luci/luci.mk package/luci.mk

# 修改编译选项为Ofast
#sed -i "s/-O[0-9a-zA-Z]\+ /-Ofast /" include/target.mk
#sed -i "s/-O[0-9a-zA-Z]\+ /-Ofast /" ./rules.mk

# 修改内核版本
#sed -i "s/KERNEL_PATCHVER:=*.*/KERNEL_PATCHVER:=5.4/g" target/linux/bcm53xx/Makefile

# only build k3
sed -i 's|^TARGET_|# TARGET_|g; s|# TARGET_DEVICES += phicomm-k3|TARGET_DEVICES += phicomm-k3|; s|# TARGET_DEVICES += phicomm_k3|TARGET_DEVICES += phicomm_k3|' target/linux/bcm53xx/image/Makefile

# 修改默认IP
sed -i 's/192.168.1.1/192.168.51.1/g' package/base-files/files/bin/config_generate

# 删除默认密码
sed -i '/\/etc\/shadow/d' package/lean/default-settings/files/zzz-default-settings

# 替换K3无线驱动为69027
rm -rf ./package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin
svn export https://github.com/xiangfeidexiaohuo/Phicomm-K3_Wireless-Firmware/trunk/brcmfmac4366c-pcie.bin_69027 ./package/lean/k3-brcmfmac4366c-firmware/files/lib/firmware/brcm/brcmfmac4366c-pcie.bin

# 添加主题
rm -rf feeds/luci/applications/luci-app-argon-config/ feeds/luci/themes/luci-theme-argon*
git clone --depth=1 -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git $LUCI_DIR/luci-theme-argon
git clone --depth=1 https://github.com/jerrykuku/luci-app-argon-config $LUCI_DIR/luci-app-argon-config

# aliyundrive
rm -rf $FEEDS_LUCI/luci-app-aliyundrive-webdav $FEEDS_PCK/aliyundrive-webdav
rm -rf $FEEDS_LUCI/luci-app-aliyundrive-fuse $FEEDS_PCK/aliyundrive-fuse
svn co https://github.com/messense/aliyundrive-webdav/trunk/openwrt $LUCI_DIR
rm -rf $LUCI_DIR/.svn
svn co https://github.com/messense/aliyundrive-fuse/trunk/openwrt $LUCI_DIR
rm -rf $LUCI_DIR/.svn

# 添加openclash
rm -rf $FEEDS_LUCI/luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash $LUCI_DIR/luci-app-openclash
mkdir -p $LUCI_DIR/luci-app-openclash/root/etc/openclash/core
svn export https://github.com/vernesong/OpenClash/trunk/core-lateset/dev/clash-linux-armv5.tar.gz $LUCI_DIR/luci-app-openclash/clash-linux-armv5.tar.gz
tar xzf $LUCI_DIR/luci-app-openclash/clash-linux-armv5.tar.gz -C $LUCI_DIR/luci-app-openclash/root/etc/openclash/core
rm $LUCI_DIR/luci-app-openclash/clash-linux-armv5.tar.gz

# k3usb
rm -rf $FEEDS_LUCI/luci-app-k3usb
svn co https://github.com/immortalwrt/luci/branches/openwrt-18.06/applications/luci-app-k3usb $LUCI_DIR/luci-app-k3usb
sed -i '/LUCI_DEPENDS/d' $LUCI_DIR/luci-app-k3usb/Makefile

# 添加新屏幕
rm -rf $FEEDS_LUCI/luci-app-k3screenctrl $FEEDS_PCK/*k3screenctrl*
rm -rf package/lean/*k3screenctrl*
git clone --depth 1 https://github.com/1005789164/luci-app-k3screenctrl.git $LUCI_DIR/luci-app-k3screenctrl
git clone --depth 1 https://github.com/1005789164/k3screenctrl_build.git $LUCI_DIR/k3screenctrl_build

# 删除防火墙命令
sed -i -r 's/(.*-t nat -A PREROUTING.*)/#\1/g' package/lean/default-settings/files/zzz-default-settings

# 修改信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='hahaha'/g" package/lean/default-settings/files/zzz-default-settings
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' oooooo-$(date +%Y%m%d) '/g" package/lean/default-settings/files/zzz-default-settings
