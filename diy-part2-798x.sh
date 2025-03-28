#!/bin/bash
set -xeuo pipefail

# =============================================
# OpenWrt DIY 终极增强版脚本
# 合并优化：网络设置 + 主机名强制写入 + 插件管理
# 版本：v4.1 (100%生效保障版)
# =============================================

# ➊ 环境验证
[ ! -f "Makefile" ] || [ ! -d "package" ] && {
    echo -e "\033[31m[错误] 必须在OpenWrt源码根目录运行！\033[0m" 
    echo "当前目录: $(pwd)"
    exit 1
}

# ➋ 初始化目录结构
ROOTFS_DIR="${PWD}/files"
mkdir -p ${ROOTFS_DIR}/{etc/uci-defaults,etc/init.d,usr/libexec}

# ➌ 核心参数配置 (保留原设置)
Ipv4_ipaddr="192.168.150.2"
Netmask_netm="255.255.255.0"
Op_name="Immortalwrt-༄ 目目+🔸࿐"
Customized_Information="༄ 目目+🔸࿐ $(TZ=UTC-8 date +%Y.%m.%d)"

# ➍ 网络基础设置
cat > ${ROOTFS_DIR}/etc/uci-defaults/10_network <<'EOF'
#!/bin/sh
# 网络设置必须最先执行
uci -q batch << EOI
set network.lan.ipaddr='192.168.150.2'
set network.lan.netmask='255.255.255.0'
set network.lan.proto='static'
set network.lan.gateway='192.168.150.1'
set network.lan.dns='192.168.151.2 223.5.5.5'
commit network
EOI
EOF

# ➎ 主机名强制写入系统 (三级保障)
cat > ${ROOTFS_DIR}/usr/libexec/force_hostname <<'EOF'
#!/bin/sh
# 原子级写入主机名
MAX_RETRY=3
for i in $(seq 1 $MAX_RETRY); do
    uci -q batch << EOI
set system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname='Immortalwrt-༄ 目目+🔸࿐'
commit system
EOI
    [ "$(uci get system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname)" = "Immortalwrt-༄ 目目+🔸࿐" ] && break
    sleep 1
done

# 最终验证
if [ "$(hostname)" != "Immortalwrt-༄ 目目+🔸࿐" ]; then
    echo "Immortalwrt-༄ 目目+🔸࿐" > /proc/sys/kernel/hostname
fi

# 写入Banner
echo "༄ 目目+🔸࿐ $(date +%Y.%m.%d)" > /etc/banner
EOF
chmod 755 ${ROOTFS_DIR}/usr/libexec/force_hostname

# 三级触发机制
cat > ${ROOTFS_DIR}/etc/uci-defaults/99_hostname <<'EOF'
#!/bin/sh
/usr/libexec/force_hostname
EOF

cat > ${ROOTFS_DIR}/etc/init.d/99_hostname <<'EOF'
#!/bin/sh
START=99
start() {
    [ "$(uci get system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname)" != "Immortalwrt-༄ 目目+🔸࿐" ] && \
        /usr/libexec/force_hostname
}
EOF
chmod 755 ${ROOTFS_DIR}/etc/init.d/99_hostname

# ➏ 插件管理 (保留原功能)
Disable_DHCP="1"
Disable_Bridge="1"
Disable_autosamba="1"

if [ "$Disable_DHCP" == "1" ]; then
    sed -i "s/CONFIG_PACKAGE_dnsmasq=y/# CONFIG_PACKAGE_dnsmasq is not set/" .config
    cat >> ${ROOTFS_DIR}/etc/uci-defaults/10_network <<'EOF'
uci set dhcp.lan.ignore='1'
commit dhcp
EOF
fi

[ "$Disable_Bridge" == "1" ] && \
    sed -i "s/CONFIG_PACKAGE_bridge=y/# CONFIG_PACKAGE_bridge is not set/" .config

[ "$Disable_autosamba" == "1" ] && {
    sed -i "s/CONFIG_PACKAGE_autosamba=y/# CONFIG_PACKAGE_autosamba is not set/" .config
    sed -i "s/CONFIG_PACKAGE_luci-app-samba=y/# CONFIG_PACKAGE_luci-app-samba is not set/" .config
}

# ➐ 主题设置
Mandatory_theme="argon"
Default_theme="argon"
[ "$Mandatory_theme" != "0" ] && {
    sed -i "s/CONFIG_PACKAGE_luci-theme-bootstrap=y/# CONFIG_PACKAGE_luci-theme-bootstrap is not set/" .config
    sed -i "s/# CONFIG_PACKAGE_luci-theme-${Mandatory_theme} is not set/CONFIG_PACKAGE_luci-theme-${Mandatory_theme}=y/" .config
}
[ "$Default_theme" != "0" ] && \
    echo "CONFIG_DEFAULT_THEME_${Default_theme}=y" >> .config

# ➑ 插件名称汉化 (保留原功能)
rename_plugins() {
    find . -type f -exec sed -i '
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
    ' {} +
}
rename_plugins

# ➒ 编译前验证
echo -e "\033[32m[最终文件结构]\033[0m"
tree -p ${ROOTFS_DIR} | head -20

echo -e "\n\033[32m[关键配置预览]\033[0m"
echo "主机名: ${Op_name}"
echo "Banner: ${Customized_Information}"
echo "IP地址: ${Ipv4_ipaddr}/${Netmask_netm}"
echo "强制写入机制:"
ls -l ${ROOTFS_DIR}/usr/libexec/force_hostname 
ls -l ${ROOTFS_DIR}/etc/uci-defaults/*hostname*

# ➓ 完成提示
cat <<EOF

\033[32m✅ 所有设置已完成！请按以下步骤操作：\033[0m

1. 清理编译环境（必须执行）:
   make dirclean && rm -rf bin/targets

2. 开始编译:
   make -j\$(nproc) V=s

3. 刷机后验证:
   ssh root@路由器IP "
     echo '=== 系统信息 ==='
     hostname
     uci get system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname
     cat /etc/banner
     echo '=== 网络设置 ==='
     uci get network.lan.ipaddr
     ifconfig br-lan | grep 'inet addr'
   "
EOF

exit 0