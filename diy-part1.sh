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
src-git passwall https://github.com/xiaorouji/openwrt-passwall-packages.git;main package/passwall-packages
# 科学passwall
src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2.git;main package/luci-app-passwall2-packages
# 科学passwall2

src-git homeproxy https://github.com/immortalwrt/homeproxy.git package/homeproxy
#  lede添加不了
src-git advancedplus https://github.com/sirpdboy/luci-app-advancedplus.git package/advancedplus  
#进阶设置   lede添加不了
src-git kucat https://github.com/sirpdboy/luci-theme-kucat.git package/kucat  
#主题
src-git filemanager https://github.com/sbwml/luci-app-filemanager.git package/filemanager 