#!/bin/bash
set -x

# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一脚本

# 增加自定义插件
git clone https://github.com/nikkinikki-org/OpenWrt-nikki package/Nikki

# --- Essential Check ---
# 确保在 OpenWrt 源码根目录下运行, 这是最常见的问题之一
if [ ! -f "Makefile" ] || [ ! -d "package" ]; then
    echo "Error: Please run this script in the OpenWrt source root directory."
    echo "Current directory: $(pwd)"
    exit 1
fi
echo "Script is running in the correct OpenWrt source directory."

# --- Define Custom Settings ---
Ipv4_ipaddr="192.168.150.2"
Netmask_netm="255.255.255.0"
Op_name="Immortalwrt-༄ 目目+🔸࿐" # 主机名
Customized_Information="༄ 目目+🔸࿐ $(TZ=UTC-8 date "+%Y.%m.%d")" # 个性签名/Banner

Kernel_partition_size="0"
Rootfs_partition_size="0"
Mandatory_theme="argon"
Default_theme="argon"
Gateway_Settings="192.168.150.1"
DNS_Settings="192.168.151.2 223.5.5.5"
Broadcast_Ipv4="192.168.150.255"
Disable_DHCP="1"
Disable_Bridge="1"
Create_Ipv6_Lan="0"
Enable_IPV6_function="0"
Enable_IPV4_function="1"
PassWall_luci_branch="0"
OpenClash_branch="0"
OpenClash_Core="1"
Replace_Kernel="0"
Password_free_login="1"
Disable_NaiveProxy="1"
Disable_autosamba="1"
Ttyd_account_free_login="0"
Delete_unnecessary_items="0"
Disable_53_redirection="1"
Cancel_running="0"

# 晶晨CPU系列设置 (如果你的目标不是amlogic, 这些可能无用)
amlogic_model="s905d"
amlogic_kernel="6.1.y_6.12.y"
auto_kernel="true"
rootfs_size="2560"
kernel_usage="stable"

# --- Prepare Custom Files Directory ---
# 创建必要的目录结构, build系统会把 files/ 下的内容合并到固件根目录
mkdir -p files/etc/uci-defaults
mkdir -p files/etc
echo "Created files/etc/ and files/etc/uci-defaults/ directories."

# --- Apply Banner Setting ---
# 直接写入 /etc/banner 文件, 用于SSH登录时显示
# 这个方法是标准的, 如果失败通常是文件未包含或被覆盖
echo "Writing custom banner to files/etc/banner..."
echo "$Customized_Information" > files/etc/banner
if [ -f "files/etc/banner" ]; then
    echo "Banner file created successfully."
else
    echo "Error: Failed to create banner file."
fi

# --- Prepare UCI Defaults Script ---
# uci-defaults 脚本会在首次启动时运行一次, 用于设置初始配置
UCI_DEFAULTS_FILE="files/etc/uci-defaults/99-custom"
echo "Creating/Clearing UCI defaults script: $UCI_DEFAULTS_FILE"
> "$UCI_DEFAULTS_FILE" # 创建或清空脚本文件

# --- Append Settings to UCI Defaults Script ---

# 调试信息: 检查此脚本是否在首次启动时运行
cat << EOF >> "$UCI_DEFAULTS_FILE"
#!/bin/sh
# This script runs once on first boot to apply initial settings

# Debug: Create files to confirm execution
touch /tmp/uci_defaults_99_custom_executed
echo "UCI defaults script 99-custom started at \$(date)" >> /tmp/uci_defaults_99_custom_log

EOF
echo "Added debug markers to $UCI_DEFAULTS_FILE"

# 应用后台IP设置
if [ "$Ipv4_ipaddr" != "0" ]; then
    echo "Adding IP address settings to $UCI_DEFAULTS_FILE..."
    cat << EOF >> "$UCI_DEFAULTS_FILE"
echo "Setting LAN IP address..." >> /tmp/uci_defaults_99_custom_log
uci set network.lan.ipaddr='$Ipv4_ipaddr'
uci set network.lan.netmask='$Netmask_netm'
uci set network.lan.proto='static' # 确保是静态IP
uci commit network
echo "LAN IP address set." >> /tmp/uci_defaults_99_custom_log
EOF
fi

# 应用主机名称设置
# 这是设置主机名的标准方法
if [ "$Op_name" != "0" ]; then
    echo "Adding hostname setting to $UCI_DEFAULTS_FILE..."
    cat << EOF >> "$UCI_DEFAULTS_FILE"
echo "Setting hostname..." >> /tmp/uci_defaults_99_custom_log
uci set system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname='$Op_name'
uci commit system
echo "Hostname set." >> /tmp/uci_defaults_99_custom_log
EOF
fi

# 应用旁路由设置
if [ "$Gateway_Settings" != "0" ] || [ "$DNS_Settings" != "0" ] || [ "$Broadcast_Ipv4" != "0" ]; then
    echo "Adding gateway/DNS/broadcast settings to $UCI_DEFAULTS_FILE..."
    cat << EOF >> "$UCI_DEFAULTS_FILE"
echo "Setting gateway/DNS/broadcast..." >> /tmp/uci_defaults_99_custom_log
[ "$Gateway_Settings" != "0" ] && uci set network.lan.gateway='$Gateway_Settings'
[ "$DNS_Settings" != "0" ] && uci set network.lan.dns='$DNS_Settings'
[ "$Broadcast_Ipv4" != "0" ] && uci set network.lan.broadcast='$Broadcast_Ipv4'
uci commit network
echo "Gateway/DNS/broadcast set." >> /tmp/uci_defaults_99_custom_log
EOF
fi

# 关闭DHCP服务 (旁路由常见设置)
if [ "$Disable_DHCP" == "1" ]; then
    echo "Adding DHCP disable setting to $UCI_DEFAULTS_FILE..."
    cat << EOF >> "$UCI_DEFAULTS_FILE"
echo "Disabling DHCP server on LAN..." >> /tmp/uci_defaults_99_custom_log
uci set dhcp.lan.ignore='1'
uci commit dhcp
echo "DHCP server disabled." >> /tmp/uci_defaults_99_custom_log
# 移除DHCP软件包可能会导致问题, 优先使用uci设置禁用它
# sed -i "s/CONFIG_PACKAGE_dnsmasq=y/# CONFIG_PACKAGE_dnsmasq is not set/" .config
# sed -i "s/CONFIG_PACKAGE_dnsmasq-full=y/# CONFIG_PACKAGE_dnsmasq-full is not set/" .config
EOF
fi

# 设置免密码登录
if [ "$Password_free_login" == "1" ]; then
    echo "Adding password-free login setting to $UCI_DEFAULTS_FILE..."
    cat << EOF >> "$UCI_DEFAULTS_FILE"
echo "Setting password-free root login..." >> /tmp/uci_defaults_99_custom_log
uci delete system.@system<source_id data="0" title="diy-part2-798x.sh" />.password
uci commit system
# Alternative: sed -i 's%root:[^:]*:%root::%' files/etc/shadow
echo "Password-free login set." >> /tmp/uci_defaults_99_custom_log
EOF
fi

# 设置ttyd免密登录
if [ "$Ttyd_account_free_login" == "1" ]; then
    echo "Adding ttyd password-free login setting to $UCI_DEFAULTS_FILE..."
    cat << EOF >> "$UCI_DEFAULTS_FILE"
echo "Setting ttyd password-free login..." >> /tmp/uci_defaults_99_custom_log
uci set ttyd.@ttyd<source_id data="0" title="diy-part2-798x.sh" />.command='/bin/login -f root' # 更可靠的方式
# uci set ttyd.@ttyd<source_id data="0" title="diy-part2-798x.sh" />.command='/bin/sh -l' # 这个可能不会继承所有环境变量
uci commit ttyd
echo "ttyd password-free login set." >> /tmp/uci_defaults_99_custom_log
EOF
fi

# 删除DNS 53端口重定向
if [ "$Disable_53_redirection" == "1" ]; then
    echo "Adding DNS redirect removal to $UCI_DEFAULTS_FILE..."
    cat << EOF >> "$UCI_DEFAULTS_FILE"
echo "Removing firewall DNS redirect rule..." >> /tmp/uci_defaults_99_custom_log
uci delete firewall.@redirect<source_id data="0" title="diy-part2-798x.sh" /> # 通常是第一个重定向规则, 如果你有多个可能需要调整
uci commit firewall
echo "Firewall DNS redirect removed." >> /tmp/uci_defaults_99_custom_log
EOF
fi

# 添加脚本结束调试信息
cat << EOF >> "$UCI_DEFAULTS_FILE"
echo "UCI defaults script 99-custom finished at \$(date)" >> /tmp/uci_defaults_99_custom_log
# 使脚本可执行
chmod +x $UCI_DEFAULTS_FILE
EOF

echo "Finished adding settings to $UCI_DEFAULTS_FILE."

# --- Apply Build Configuration Changes (.config) ---
# 这些修改直接作用于 .config 文件, 影响编译过程

echo "Applying .config modifications..."

# 应用分区大小设置 (需要目标架构支持)
if [ "$Kernel_partition_size" != "0" ]; then
    echo "Setting kernel partition size to $Kernel_partition_size MB..."
    sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$Kernel_partition_size/" .config
fi
if [ "$Rootfs_partition_size" != "0" ]; then
    echo "Setting rootfs partition size to $Rootfs_partition_size MB..."
    sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$Rootfs_partition_size/" .config
fi

# 应用主题设置
if [ "$Mandatory_theme" != "0" ]; then
    echo "Setting mandatory theme to $Mandatory_theme..."
    sed -i "s/CONFIG_PACKAGE_luci-theme-bootstrap=y/# CONFIG_PACKAGE_luci-theme-bootstrap is not set/" .config
    sed -i "/CONFIG_PACKAGE_luci-theme-$Mandatory_theme/ s/# *CONFIG_PACKAGE_luci-theme-$Mandatory_theme is not set/CONFIG_PACKAGE_luci-theme-$Mandatory_theme=y/" .config
fi
if [ "$Default_theme" != "0" ]; then
    echo "Setting default theme to $Default_theme..."
    # sed -i "s/CONFIG_DEFAULT_THEME=.*/CONFIG_DEFAULT_THEME=\"$Default_theme\"/" .config # 旧方法
    sed -i "/CONFIG_DEFAULT_THEME_/d" .config # 删除所有旧的默认主题设置
    echo "CONFIG_DEFAULT_THEME_$Default_theme=y" >> .config # 添加新的默认主题设置
    sed -i "s/CONFIG_LUCI_LANG_DEFAULT=.*/CONFIG_LUCI_LANG_DEFAULT=\"zh_Hans\"/" .config # 顺便设置默认中文
fi

# 去掉桥接模式 (如果禁用DHCP, 通常也需要这个)
if [ "$Disable_Bridge" == "1" ]; then
    echo "Disabling bridge interface package..."
    sed -i "s/CONFIG_BRIDGE=y/# CONFIG_BRIDGE is not set/" .config
    # 注意: 这只移除了 bridge 工具包, lan接口本身是否桥接由 network 配置决定
fi

# 创建IPV6 lan口 (通常与Enable_IPV6_function一起用)
if [ "$Create_Ipv6_Lan" == "1" ] && [ "$Enable_IPV6_function" == "1" ]; then
    echo "Enabling IPv6 helper package for LAN..."
    sed -i "/CONFIG_PACKAGE_ipv6helper/ s/# *CONFIG_PACKAGE_ipv6helper is not set/CONFIG_PACKAGE_ipv6helper=y/" .config
fi

# 启用IPV6/IPV4 (确保相关包被选中)
if [ "$Enable_IPV6_function" == "1" ]; then
    echo "Ensuring IPv6 helper package is enabled..."
    sed -i "/CONFIG_PACKAGE_ipv6helper/ s/# *CONFIG_PACKAGE_ipv6helper is not set/CONFIG_PACKAGE_ipv6helper=y/" .config
fi
# IPV4 通常默认启用,无需修改 .config

# 应用OpenClash设置 (仅选择包)
if [ "$OpenClash_Core" != "0" ]; then
    echo "Ensuring OpenClash package is selected..."
    sed -i "/CONFIG_PACKAGE_luci-app-openclash/ s/# *CONFIG_PACKAGE_luci-app-openclash is not set/CONFIG_PACKAGE_luci-app-openclash=y/" .config
fi

# 更换固件内核版本 (需要内核源码支持)
if [ "$Replace_Kernel" != "0" ]; then
    echo "Setting target kernel version to $Replace_Kernel..."
    sed -i "s/CONFIG_TARGET_KERNEL_VERSION=.*/CONFIG_TARGET_KERNEL_VERSION=\"$Replace_Kernel\"/" .config
fi

# 禁用ssrplus和passwall的NaiveProxy依赖
if [ "$Disable_NaiveProxy" == "1" ]; then
    echo "Disabling NaiveProxy package..."
    sed -i "s/CONFIG_PACKAGE_naiveproxy=y/# CONFIG_PACKAGE_naiveproxy is not set/" .config
fi

# 去除网络共享(autosamba)
if [ "$Disable_autosamba" == "1" ]; then
    echo "Disabling Samba packages..."
    sed -i "s/CONFIG_PACKAGE_luci-app-samba=y/# CONFIG_PACKAGE_luci-app-samba is not set/" .config
    sed -i "s/CONFIG_PACKAGE_luci-app-samba4=y/# CONFIG_PACKAGE_luci-app-samba4 is not set/" .config
    sed -i "s/CONFIG_PACKAGE_autosamba=y/# CONFIG_PACKAGE_autosamba is not set/" .config
fi

echo ".config modifications applied."

# --- Modify Plugin Names (Cosmetic) ---
echo "Modifying plugin display names..."
# (保持你原来的修改逻辑)
for file in $(grep -rl '"终端"' ./); do [ -f "$file" ] && sed -i 's/"终端"/"终端"/g' "$file"; done
for file in $(grep -rl '"aMule设置"' ./); do [ -f "$file" ] && sed -i 's/"aMule设置"/"电驴下载"/g' "$file"; done
for file in $(grep -rl '"网络存储"' ./); do [ -f "$file" ] && sed -i 's/"网络存储"/"NAS"/g' "$file"; done
for file in $(grep -rl '"Turbo ACC 网络加速"' ./); do [ -f "$file" ] && sed -i 's/"Turbo ACC 网络加速"/"网络加速"/g' "$file"; done
for file in $(grep -rl '"实时流量监测"' ./); do [ -f "$file" ] && sed -i 's/"实时流量监测"/"流量"/g' "$file"; done
for file in $(grep -rl '"KMS 服务器"' ./); do [ -f "$file" ] && sed -i 's/"KMS 服务器"/"KMS激活"/g' "$file"; done
for file in $(grep -rl '"TTYD 终端"' ./); do [ -f "$file" ] && sed -i 's/"TTYD 终端"/"TTYD终端"/g' "$file"; done
for file in $(grep -rl '"USB 打印服务器"' ./); do [ -f "$file" ] && sed -i 's/"USB 打印服务器"/"打印服务"/g' "$file"; done
for file in $(grep -rl '"Web 管理"' ./); do [ -f "$file" ] && sed -i 's/"Web 管理"/"Web管理"/g' "$file"; done
for file in $(grep -rl '"管理权"' ./); do [ -f "$file" ] && sed -i 's/"管理权"/"管理权"/g' "$file"; done
for file in $(grep -rl '"带宽监控"' ./); do [ -f "$file" ] && sed -i 's/"带宽监控"/"监控"/g' "$file"; done
echo "Plugin names modification finished."

# --- Define Cleanup Files (Optional) ---
# These are used by specific build workflows, may not be relevant for manual builds
CLEAR_PATH="/tmp/clear.txt"
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
sha256sums
version.buildinfo
profiles.json
# Adjust for your specific target, e.g., x86/64
# openwrt-x86-64-generic-kernel.bin
# openwrt-x86-64-generic.manifest
# openwrt-x86-64-generic-squashfs-rootfs.img.gz
EOF

DELETE=${DELETE:-"/tmp/delete.txt"}
cat >>"$DELETE" <<-EOF
# Add files here to delete during online update if needed
EOF

echo "Cleanup file lists created."

# --- Final Check ---
echo "Checking final files/ directory contents:"
ls -R files/

echo "-------------------------------------------------------------------------"
echo "diy-part2 script finished."
echo "Reminder: Ensure you run this script from the OpenWrt source root."
echo "It's highly recommended to run 'make clean' or 'make dirclean'"
echo "before rebuilding if you encountered issues previously."
echo "After flashing, check /tmp/uci_defaults_99_custom_* files for debug info"
echo "and verify hostname with 'uci get system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname' or 'hostname',"
echo "and banner with 'cat /etc/banner'."
echo "-------------------------------------------------------------------------"

exit 0