#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
# echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall-packages' >>feeds.conf.default
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall-packages.git;main package/passwall-packages
# 科学passwall
echo 'src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2' >>feeds.conf.default
# 科学passwall2

echo 'src-git homeproxy https://github.com/immortalwrt/homeproxy' >>feeds.conf.default
#  lede添加不了
echo 'src-git advancedplus https://github.com/sirpdboy/luci-app-advancedplus' >>feeds.conf.default
#进阶设置   lede添加不了
echo 'src-git kucat https://github.com/sirpdboy/luci-theme-kucat' >>feeds.conf.default
#主题
echo 'src-git filemanager https://github.com/sbwml/luci-app-filemanager' >>feeds.conf.default