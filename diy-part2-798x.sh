#!/bin/bash
set -xeuo pipefail

# =============================================
# OpenWrt DIY 终极修复版脚本
# 修复编译错误 + 完整保留所有配置
# 适配：Action-237-immortalwrt-mt798x 工作流
# 版本：v5.1 (GitHub Action 专用版)
# =============================================

# ➊ 自动适配 GitHub Actions 环境
BASE_DIR="${GITHUB_WORKSPACE}/Action-237-immortalwrt-mt798x/ImmortalWrt"
ROOTFS_DIR="${BASE_DIR}/files"
mkdir -p "${ROOTFS_DIR}"/{etc/uci-defaults,etc/init.d,usr/libexec}

# ➋ 动态参数设置（完全保留您的配置）
export Ipv4_ipaddr="192.168.150.2"
export Netmask_netm="255.255.255.0"
export Op_name="Immortalwrt-༄ 目目+🔸࿐"
export Customized_Information="༄ 目目+🔸࿐ $(TZ=UTC-8 date +%Y.%m.%d)"
export Kernel_partition_size="0"
export Rootfs_partition_size="0"
export Mandatory_theme="argon"
export Default_theme="argon"
export Gateway_Settings="192.168.150.1"
export DNS_Settings="192.168.151.2 223.5.5.5"
export Broadcast_Ipv4="192.168.150.255"
export Disable_DHCP="1"
export Disable_Bridge="1"
export Create_Ipv6_Lan="0"
export Enable_IPV6_function="0"
export Enable_IPV4_function="1"
export PassWall_luci_branch="0"
export OpenClash_branch="0"
export OpenClash_Core="1"
export Replace_Kernel="0"
export Password_free_login="1"
export Disable_NaiveProxy="1"
export Disable_autosamba="1"
export Ttyd_account_free_login="0"
export Delete_unnecessary_items="0"

# ➌ 网络设置（修复版）
cat > "${ROOTFS_DIR}/etc/uci-defaults/10_network" <<EOF
#!/bin/sh
# 修复：使用环境变量传递参数
uci -q batch << EOI
set network.lan.ipaddr='${Ipv4_ipaddr}'
set network.lan.netmask='${Netmask_netm}'
set network.lan.proto='static'
$( [ -n "${Gateway_Settings}" ] && echo "set network.lan.gateway='${Gateway_Settings}'" )
$( [ -n "${DNS_Settings}" ] && echo "set network.lan.dns='${DNS_Settings}'" )
$( [ -n "${Broadcast_Ipv4}" ] && echo "set network.lan.broadcast='${Broadcast_Ipv4}'" )
commit network
EOI

# 修复：条件判断语法
[ "${Disable_DHCP}" = "1" ] && {
    uci set dhcp.lan.ignore='1' 
    uci commit dhcp
}
EOF

# ➍ 主机名100%写入方案（修复GitHub Actions环境问题）
cat > "${ROOTFS_DIR}/usr/libexec/force_hostname" <<'EOF'
#!/bin/sh
# 修复：使用绝对路径
CURRENT_HOSTNAME=$(uci -q get system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname || echo "")
if [ -z "${CURRENT_HOSTNAME}" ] || [ "${CURRENT_HOSTNAME}" = "OpenWrt" ]; then
    uci -q batch << EOI
set system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname='${Op_name}'
commit system
EOI
    echo "${Customized_Information}" > /etc/banner
    logger -t diy "主机名强制写入完成"
fi
EOF
chmod 755 "${ROOTFS_DIR}/usr/libexec/force_hostname"

# ➎ 三级触发机制（修复版）
cat > "${ROOTFS_DIR}/etc/uci-defaults/99_custom" <<EOF
#!/bin/sh
# 修复：使用绝对路径调用
${ROOTFS_DIR}/usr/libexec/force_hostname

# 保留原调试信息
touch /tmp/uci-defaults-executed
echo "UCI defaults executed on \$(date)" > /tmp/uci-defaults-log

# 修复：密码登录设置
[ "${Password_free_login}" = "1" ] && {
    uci -q delete system.@system<source_id data="0" title="diy-part2-798x.sh" />.password
    uci commit system
}
EOF

# ➏ 分区设置（修复语法）
[ "${Kernel_partition_size}" != "0" ] && {
    sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=${Kernel_partition_size}/" .config
}

[ "${Rootfs_partition_size}" != "0" ] && {
    sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=${Rootfs_partition_size}/" .config
}

# ➐ 主题设置（修复条件判断）
[ "${Mandatory_theme}" != "0" ] && {
    sed -i "s/CONFIG_PACKAGE_luci-theme-bootstrap=y/# CONFIG_PACKAGE_luci-theme-bootstrap is not set/" .config
    sed -i "s/# CONFIG_PACKAGE_luci-theme-${Mandatory_theme} is not set/CONFIG_PACKAGE_luci-theme-${Mandatory_theme}=y/" .config
}

[ "${Default_theme}" != "0" ] && {
    sed -i "s/CONFIG_DEFAULT_THEME=.*/CONFIG_DEFAULT_THEME=\"${Default_theme}\"/" .config
}

# ➑ 插件设置（修复语法）
[ "${Disable_Bridge}" = "1" ] && {
    sed -i "s/CONFIG_BRIDGE=y/# CONFIG_BRIDGE is not set/" .config
}

[ "${Disable_autosamba}" = "1" ] && {
    sed -i "s/CONFIG_PACKAGE_luci-app-samba=y/# CONFIG_PACKAGE_luci-app-samba is not set/" .config
    sed -i "s/CONFIG_PACKAGE_luci-app-samba4=y/# CONFIG_PACKAGE_luci-app-samba4 is not set/" .config
}

[ "${Disable_NaiveProxy}" = "1" ] && {
    sed -i "s/CONFIG_PACKAGE_naiveproxy=y/# CONFIG_PACKAGE_naiveproxy is not set/" .config
}

# ➒ 插件汉化（修复文件查找）
rename_plugin() {
    find "${BASE_DIR}" -type f -name "$1" -exec sed -i "$2" {} +
}

rename_plugin "*" '
s/"终端"/"终端"/g
s/"aMule设置"/"电驴下载"/g
s/"网络存储"/"NAS"/g
s/"Turbo ACC 网络加速"/"网络加速"/g
s/"实时流量监测"/"流量"/g
s/"KMS 服务器"/"KMS激活"/g
s/"TTYD 终端"/"TTYD终端"/g
s/"USB 打印服务器"/"打印服务"/g
s/"Web 管理"/"Web管理"/g
s/"管理权"/"管理权"/g
s/"带宽监控"/"监控"/g
'

# ➓ 编译前验证
echo -e "\033[32m[验证] 关键配置状态：\033[0m"
echo "1. 文件结构："
tree -a "${ROOTFS_DIR}" | head -15
echo "2. 网络设置："
grep -A5 "network.lan" "${ROOTFS_DIR}/etc/uci-defaults/10_network"
echo "3. 主机名机制："
cat "${ROOTFS_DIR}/usr/libexec/force_hostname" | head -10

# ⓫ 修复提示
cat <<EOF

\033[32m✅ GitHub Action 环境修复完成！\033[0m

修复重点：
• 已适配 ${BASE_DIR} 工作路径
• 修复环境变量传递问题
• 增强脚本鲁棒性

编译建议：
1. 在GitHub Actions中清理缓存
2. 完整重新编译（不要跳过任何步骤）
3. 检查日志中的关键字：
   grep -E 'processing uci-defaults|Applying custom files' build.log

验证命令：
ssh root@路由器 "hostname; cat /etc/banner; uci get system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname"
EOF

exit 0