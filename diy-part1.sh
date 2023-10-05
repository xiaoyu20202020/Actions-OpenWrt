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
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default

#修改内核版本
sed -i 's/KERNEL_TESTING_PATCHVER:=5.15/KERNEL_TESTING_PATCHVER:=5.4 /g' target/linux/ramips/Makefile

#修改root密码为空
#sed -i 's/root:$1$26qPRdbV$j9PQ1CCliyiydNI1uRxbH/:19598:0:99999:7:::/root:password/g' package/lean/default-settings/files/zzz-default-settings
sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# Modify default theme修改默认主题
rm -rf package/lean/luci-theme-bootstrap
# rm -rf package/lean/luci-theme-argon
# find ./ -name luci-theme-argon | xargs rm -rf;
# find ./ -name luci-app-argon-config | xargs rm -rf;
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/lean/luci-theme-argon

# K2P-32M修改编译文件
sed -i 's/"Phicomm K2P";/"Phicomm K2P (32M)";/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i '/spi-max-frequency/a\\t\tbroken-flash-reset;' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i 's/<0xa0000 0xf60000>/<0xa0000 0x1fb0000>/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i 's/15744k/32448k/g' target/linux/ramips/image/mt7621.mk
sed -i 's/OpenWrt/K2P-32M/g' package/base-files/files/bin/config_generate
sed -i 's/<80000000>/<10000000>/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts
sed -i 's/m25p,fast-read;/broken-flash-reset;/g' target/linux/ramips/dts/mt7621_phicomm_k2p.dts

# 第三方插件
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

# 编译最新passwall去config增加passwall的选项
# git clone https://github.com/xiaorouji/openwrt-passwall.git -b packages ./package/lean/passwall_package
# git clone https://github.com/xiaorouji/openwrt-passwall.git -b luci ./package/lean/passwall
# cp -rf ./package/lean/passwall_package/* ./package/lean/passwall
# rm -rf ./package/lean/passwall_package


# 编译指定版本的passwall
# git clone-b packages ./package/passwall_package
# git clone-b luci ./package/passwall_luci
# cp -rf ./package/passwall_package/* ./package/passwall
# rm -rf ./package/passwall_package
# cd ./package/passwall
# git checkout 0a9c9f8 # 这是4.68-5版本的commit ID
# cd ../../

git clone https://github.com/xiaorouji/openwrt-passwall.git -b packages ./package/passwall_package
git clone https://github.com/xiaorouji/openwrt-passwall.git -b luci ./package/passwall_luci
cp -rf ./package/passwall_package/* ./package/passwall
rm -rf ./package/passwall_package
cd ./package/passwall
git checkout 0a9c9f8 # 这是4.68-5版本的commit ID
git reset --hard 0a9c9f8 # 这是为了回退到4.68-5版本
git pull # 这是为了获取最新的更新
git checkout 3d6e0f3 # 这是4.66-8版本的commit ID
cd ../../
