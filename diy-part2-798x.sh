#!/bin/bash
# DIY扩展第二部分脚本
# 包含自定义插件、网络设置、主题设置等

# 添加自定义插件
echo "添加自定义插件..."
git clone https://github.com/nikkinikki-org/OpenWrt-nikki package/Nikki
git clone https://github.com/281677160/luci-app-autoupdate package/autoupdate

# 基本系统设置
export Ipv4_ipaddr="192.168.150.2"
export Netmask_netm="255.255.255.0"
export Op_name="༄ 目目+࿐"

# 分区设置
export Kernel_partition_size="0"
export Rootfs_partition_size="0"

# 主题设置
export Mandatory_theme="argon"
export Default_theme="argon"

# 旁路由设置
export Gateway_Settings="192.168.150.1"
export DNS_Settings="192.168.151.2 223.5.5.5"
export Broadcast_Ipv4="0"
export Disable_DHCP="1"
export Disable_Bridge="1"
export Create_Ipv6_Lan="0"

# IP协议设置
export Enable_IPV6_function="0"
export Enable_IPV4_function="0"

# OpenClash设置
export OpenClash_branch="0"

# 个性化设置
export Customized_Information="༄ 目目+࿐$(TZ=UTC-8 date "+%Y.%m.%d")"

# 内核与安全设置
export Replace_Kernel="0"
export Password_free_login="1"
export AdGuardHome_Core="0"
export Disable_NaiveProxy="0"

# 功能设置
export Automatic_Mount_Settings="0"
export Disable_autosamba="1"
export Ttyd_account_free_login="0"
export Delete_unnecessary_items="0"
export Disable_53_redirection="0"
export Cancel_running="0"

# 晶晨CPU设置
export amlogic_model="s905d"
export amlogic_kernel="5.10.01_6.1.01"
export auto_kernel="true"
export rootfs_size="2560"
export kernel_usage="stable"

# 修改插件显示名称
echo "修改插件显示名称..."
sed -i 's/"终端"/"终端TTYD"/g' `egrep "终端" -rl ./`
sed -i 's/"网络存储"/"NAS"/g' `egrep "网络存储" -rl ./`
sed -i 's/"实时流量监测"/"流量"/g' `egrep "实时流量监测" -rl ./`
sed -i 's/"KMS 服务器"/"KMS激活"/g' `egrep "KMS 服务器" -rl ./`
sed -i 's/"USB 打印服务器"/"打印服务"/g' `egrep "USB 打印服务器" -rl ./`
sed -i 's/"Web 管理"/"Web管理"/g' `egrep "Web 管理" -rl ./`
sed -i 's/"管理权"/"管理权"/g' `egrep "管理权" -rl ./`
sed -i 's/"带宽监控"/"带宽监控"/g' `egrep "带宽监控" -rl ./`

# 清理不需要的文件
echo "设置清理列表..."
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
sha256sums
version.buildinfo
profiles.json
openwrt-x86-64-generic-kernel.bin
openwrt-x86-64-generic.manifest
openwrt-x86-64-generic-squashfs-rootfs.img.gz
EOF

# 在线更新时删除的文件
cat >>$DELETE <<-EOF
EOF

echo "diy-part2 脚本执行完成"