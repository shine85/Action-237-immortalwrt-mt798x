#!/bin/bash
set -x

# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好
git clone https://github.com/nikkinikki-org/OpenWrt-nikki package/Nikki

# 后台IP设置
Ipv4_ipaddr="192.168.150.2" # 修改openwrt后台地址(填0为关闭)
Netmask_netm="255.255.255.0" # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
Op_name="Immortalwrt-༄ 目目+🔸࿐" # 修改主机名称为OpenWrt-123(填0为不作修改)

# 应用后台IP和主机名称设置到固件
if [ "$Ipv4_ipaddr" != "0" ]; then
    mkdir -p files/etc/uci-defaults
    cat << EOF > files/etc/uci-defaults/99-custom
uci set network.lan.ipaddr='$Ipv4_ipaddr'
uci set network.lan.netmask='$Netmask_netm'
uci commit network
EOF
fi
if [ "$Op_name" != "0" ]; then
    sed -i "s/CONFIG_HOSTNAME=.*/CONFIG_HOSTNAME=\"$Op_name\"/" .config
fi

# 内核和系统分区大小(不是每个机型都可用)
Kernel_partition_size="0" # 内核分区大小(单位MB,填0为不作修改)
Rootfs_partition_size="0" # 系统分区大小(单位MB,填0为不作修改)

# 应用分区大小设置（仅适用于支持的机型）
if [ "$Kernel_partition_size" != "0" ]; then
    sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$Kernel_partition_size/" .config
fi
if [ "$Rootfs_partition_size" != "0" ]; then
    sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$Rootfs_partition_size/" .config
fi

# 默认主题设置
Mandatory_theme="argon" # 必选主题(填0为不作修改)
Default_theme="argon" # 默认第一主题(填0为不作修改)

# 应用主题设置
if [ "$Mandatory_theme" != "0" ]; then
    sed -i "s/CONFIG_PACKAGE_luci-theme-bootstrap=y/# CONFIG_PACKAGE_luci-theme-bootstrap is not set/" .config
    sed -i "s/# CONFIG_PACKAGE_luci-theme-$Mandatory_theme is not set/CONFIG_PACKAGE_luci-theme-$Mandatory_theme=y/" .config
fi
if [ "$Default_theme" != "0" ]; then
    sed -i "s/CONFIG_DEFAULT_THEME=.*/CONFIG_DEFAULT_THEME=\"$Default_theme\"/" .config
fi

# 旁路由选项
Gateway_Settings="192.168.150.1" # IPv4 网关(填0为不作修改)
DNS_Settings="192.168.151.2 223.5.5.5" # DNS设置(填0为不作修改)
Broadcast_Ipv4="192.168.150.255" # IPv4 广播(填0为不作修改)
Disable_DHCP="1" # 关闭DHCP功能(1为启用,0为不作修改)
Disable_Bridge="1" # 去掉桥接模式(1为启用,0为不作修改)
Create_Ipv6_Lan="0" # 创建IPV6 lan口(1为启用,0为不作修改)

# 应用旁路由设置
if [ "$Gateway_Settings" != "0" ] || [ "$DNS_Settings" != "0" ] || [ "$Broadcast_Ipv4" != "0" ]; then
    mkdir -p files/etc/uci-defaults
    cat << EOF > files/etc/uci-defaults/98-bypass
uci set network.lan.proto='static'
[ "$Gateway_Settings" != "0" ] && uci set network.lan.gateway='$Gateway_Settings'
[ "$DNS_Settings" != "0" ] && uci set network.lan.dns='$DNS_Settings'
[ "$Broadcast_Ipv4" != "0" ] && uci set network.lan.broadcast='$Broadcast_Ipv4'
uci commit network
EOF
fi
if [ "$Disable_DHCP" == "1" ]; then
    sed -i "s/CONFIG_PACKAGE_dhcp=y/# CONFIG_PACKAGE_dhcp is not set/" .config
    mkdir -p files/etc/uci-defaults
    cat << EOF >> files/etc/uci-defaults/99-custom
uci set dhcp.lan.ignore='1'
uci commit dhcp
EOF
fi
if [ "$Disable_Bridge" == "1" ]; then
    sed -i "s/CONFIG_BRIDGE=y/# CONFIG_BRIDGE is not set/" .config
fi
if [ "$Create_Ipv6_Lan" == "1" ]; then
    sed -i "s/# CONFIG_PACKAGE_ipv6helper is not set/CONFIG_PACKAGE_ipv6helper=y/" .config
fi

# IPV6、IPV4 选择
Enable_IPV6_function="0" # 启用IPV6(1为启用,0为不作修改)
Enable_IPV4_function="1" # 启用IPV4(1为启用,0为不作修改)

# 应用IPV6/IPV4设置
if [ "$Enable_IPV6_function" == "1" ]; then
    sed -i "s/# CONFIG_PACKAGE_ipv6helper is not set/CONFIG_PACKAGE_ipv6helper=y/" .config
    [ "$Create_Ipv6_Lan" == "1" ] && Create_Ipv6_Lan="0" # 如果启用IPV6，则禁用Create_Ipv6_Lan
fi
if [ "$Enable_IPV4_function" == "1" ]; then
    sed -i "s/# CONFIG_PACKAGE_ipv4helper is not set/CONFIG_PACKAGE_ipv4helper=y/" .config
fi

# 替换passwall的源码(暂不实现具体替换逻辑，仅定义变量)
PassWall_luci_branch="0" # 0为luci分支,1为luci-smartdns-new-version分支

# 替换OpenClash的源码和核心
OpenClash_branch="0" # 0为master分支,1为dev分支
OpenClash_Core="1" # 1为dev单核,2为dev/meta/premium三核,0为不下载

# 应用OpenClash设置（需手动确认源码是否支持）
if [ "$OpenClash_Core" != "0" ]; then
    sed -i "s/# CONFIG_PACKAGE_luci-app-openclash is not set/CONFIG_PACKAGE_luci-app-openclash=y/" .config
fi

# 个性签名
Customized_Information="༄ 目目+🔸࿐ $(TZ=UTC-8 date "+%Y.%m.%d")"
# 应用个性签名
echo "$Customized_Information" > files/etc/banner

# 更换固件内核
Replace_Kernel="0" # 填入内核版本号(填0为不作修改)
if [ "$Replace_Kernel" != "0" ]; then
    sed -i "s/CONFIG_TARGET_KERNEL_VERSION=.*/CONFIG_TARGET_KERNEL_VERSION=\"$Replace_Kernel\"/" .config
fi

# 设置免密码登录
Password_free_login="1" # 1为启用,0为不作修改
if [ "$Password_free_login" == "1" ]; then
    mkdir -p files/etc/uci-defaults
    cat << EOF >> files/etc/uci-defaults/99-custom
uci set system.@system<source_id data="0" title="build-x86_64.yml" />.password=""
uci commit system
EOF
fi

# 禁用ssrplus和passwall的NaiveProxy
Disable_NaiveProxy="1" # 1为禁用,0为不作修改
if [ "$Disable_NaiveProxy" == "1" ]; then
    sed -i "s/CONFIG_PACKAGE_naiveproxy=y/# CONFIG_PACKAGE_naiveproxy is not set/" .config
fi

# 去除网络共享(autosamba)
Disable_autosamba="1" # 1为启用,0为不作修改
if [ "$Disable_autosamba" == "1" ]; then
    sed -i "s/CONFIG_PACKAGE_luci-app-samba=y/# CONFIG_PACKAGE_luci-app-samba is not set/" .config
    sed -i "s/CONFIG_PACKAGE_luci-app-samba4=y/# CONFIG_PACKAGE_luci-app-samba4 is not set/" .config
fi

# 其他设置
Ttyd_account_free_login="0" # 设置ttyd免密登录(1为启用,0为不作修改)
Delete_unnecessary_items="0" # 删除其他机型固件(1为启用,0为不作修改)
Disable_53_redirection="1" # 删除DNS 53端口重定向(1为启用,0为不作修改)
Cancel_running="0" # 取消跑分任务(1为启用,0为不作修改)

if [ "$Ttyd_account_free_login" == "1" ]; then
    mkdir -p files/etc/uci-defaults
    cat << EOF >> files/etc/uci-defaults/99-custom
uci set ttyd.@ttyd<source_id data="0" title="build-x86_64.yml" />.command='/bin/sh -l'
uci commit ttyd
EOF
fi
if [ "$Disable_53_redirection" == "1" ]; then
    mkdir -p files/etc/uci-defaults
    cat << EOF >> files/etc/uci-defaults/99-custom
uci del firewall.@redirect<source_id data="0" title="build-x86_64.yml" />
uci commit firewall
EOF
fi

# 晶晨CPU系列打包固件设置（仅适用于特定机型）
amlogic_model="s905d"
amlogic_kernel="6.1.y_6.12.y"
auto_kernel="true"
rootfs_size="2560"
kernel_usage="stable"
# 晶晨设置通常由其他脚本处理，此处仅保留变量定义

# 修改插件名字（保持原有逻辑）
for file in $(egrep "终端" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"终端"/"TTYD"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "aMule设置" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"aMule设置"/"电驴下载"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "网络存储" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"网络存储"/"NAS"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "Turbo ACC 网络加速" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "实时流量监测" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"实时流量监测"/"流量"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "KMS 服务器" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"KMS 服务器"/"KMS激活"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "TTYD 终端" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"TTYD 终端"/"TTYD终端"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "USB 打印服务器" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"USB 打印服务器"/"打印服务"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "Web 管理" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"Web 管理"/"Web管理"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "管理权" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"管理权"/"管理权"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

for file in $(egrep "带宽监控" -rl ./); do
    if [ -f "$file" ]; then
        sed -i 's/"带宽监控"/"监控"/g' "$file"
    else
        echo "Warning: $file not found"
    fi
done

# 整理固件包时候,删除不需要的文件
CLEAR_PATH="/tmp/clear.txt"
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
sha256sums
version.buildinfo
profiles.json
profiles.json
Source code(zip)
Source code(tar.gz)
openwrt-x86-64-generic-kernel.bin
openwrt-x86-64-generic.manifest
openwrt-x86-64-generic-squashfs-rootfs.img.gz
EOF

# 在线更新时，删除不想保留的文件
DELETE=${DELETE:-"/tmp/delete.txt"}
cat >>"$DELETE" <<-EOF
EOF