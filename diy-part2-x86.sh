#!/bin/bash
set -x

# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了,在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的,多了没用,增加编译错误,自己需要的才好
git clone https://github.com/nikkinikki-org/OpenWrt-nikki package/Nikki

# 后台IP设置 (留着，但这次我们主要看文件生成)
export Ipv4_ipaddr="192.168.250.3"
export Netmask_netm="255.255.255.0"
export Op_name="Immortalwrt-DIY-TEST" # 修改主机名称为Immortalwrt-DIY-TEST

# 默认主题设置 (留着)
export Default_theme="argon"

# ----------------------  配置生成部分 (MODIFIED for DEBUGGING) ----------------------

# 确保 files/etc/config 目录存在
mkdir -p files/etc/config

# 生成 network 配置文件 (简化内容)
cat > files/etc/config/network <<EOF
config interface 'lan'
        option proto 'static'
        option ipaddr "$Ipv4_ipaddr"
        option netmask "$Netmask_netm"
EOF

# 生成 system 配置文件 (简化内容)
cat > files/etc/config/system <<EOF
config system
        option hostname "$Op_name"
EOF

# 生成 luci 配置文件 (简化内容)
cat > files/etc/config/luci <<EOF
config core 'main'
        option theme "$Default_theme"
EOF

# 生成 dhcp 配置文件 (简化内容)
cat > files/etc/config/dhcp <<EOF
config dnsmasq
        option domainneeded '1'
EOF

# ----------------------  新增的调试输出  ----------------------

echo "------------------ 检查 files/etc/config 目录内容 ------------------"
ls -R files/etc/config
echo "------------------ 检查 files 目录结构 ------------------"
ls -R files
echo "------------------ DIY Part 2 脚本执行完毕 ------------------"


# ----------------------  以下为界面文字替换部分 (注释掉)  ----------------------
# ... (界面文字替换部分全部注释掉) ...


# ----------------------  以下为清理文件部分 (注释掉)  ----------------------
# ... (清理文件部分全部注释掉) ...