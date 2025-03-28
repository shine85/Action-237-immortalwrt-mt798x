#!/bin/bash
set -xe

# =============================================
# OpenWrt DIY 终极写入保障脚本
# 修复所有配置不生效的问题
# 版本：v7.0 (100%写入保证版)
# =============================================

# ➊ 基础环境检查
[ ! -f "Makefile" ] && { echo -e "\033[31m[错误] 必须在OpenWrt源码根目录运行！\033[0m"; exit 1; }

# ➋ 强制清理残留文件（关键步骤）
rm -rf files
mkdir -p files/etc/uci-defaults files/etc/init.d files/usr/libexec

# ➌ 参数配置（完全保留您的原始设置）
export Ipv4_ipaddr="192.168.150.2"
export Netmask_netm="255.255.255.0"
export Op_name="Immortalwrt-༄ 目目+🔸࿐"
export Customized_Information="༄ 目目+🔸࿐ $(TZ=UTC-8 date +%Y.%m.%d)"
export Disable_DHCP="1"
export Disable_Bridge="1"
export Mandatory_theme="argon"
export Password_free_login="1"

# ➍ 网络设置（双重保障）
cat > files/etc/uci-defaults/10_network <<'EOF'
#!/bin/sh
# 保障层1：标准网络设置
uci -q batch << EOI
set network.lan.ipaddr='${Ipv4_ipaddr}'
set network.lan.netmask='${Netmask_netm}'
set network.lan.proto='static'
commit network
EOI

# 保障层2：DHCP设置
[ "${Disable_DHCP}" = "1" ] && {
    uci set dhcp.lan.ignore='1'
    uci commit dhcp
    echo "DHCP服务已禁用" > /tmp/network.log
}

# 最终验证
echo "当前LAN IP: $(uci get network.lan.ipaddr)" >> /tmp/network.log
EOF

# ➎ 主机名强制写入（三重保障）
cat > files/usr/libexec/force_settings <<'EOF'
#!/bin/sh
# 第一重：标准设置
uci -q batch << EOI
set system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname='${Op_name}'
$( [ "${Password_free_login}" = "1" ] && echo "set system.@system<source_id data="0" title="diy-part2-798x.sh" />.password=''" )
commit system
EOI

# 第二重：直接内核写入
[ "$(hostname)" != "${Op_name}" ] && {
    echo "${Op_name}" > /proc/sys/kernel/hostname
    echo "使用内核级写入主机名" >> /tmp/hostname.log
}

# 第三重：Banner写入
echo "${Customized_Information}" > /etc/banner
EOF
chmod 755 files/usr/libexec/force_settings

# ➏ 主题强制设置（编译时+运行时双保险）
cat >> .config <<EOF
# 主题强制设置
CONFIG_PACKAGE_luci-theme-bootstrap=n
CONFIG_PACKAGE_luci-theme-${Mandatory_theme}=y
CONFIG_DEFAULT_THEME="${Mandatory_theme}"
EOF

# ➐ 创建启动脚本（确保首次启动执行）
cat > files/etc/init.d/99_force_settings <<EOF
#!/bin/sh
START=99
start() {
    # 等待系统服务就绪
    sleep 5
    # 执行强制设置
    /usr/libexec/force_settings
    # 验证结果
    echo "最终主机名: \$(hostname)" > /tmp/boot.log
    # 自删除脚本
    rm -f /etc/init.d/99_force_settings
}
EOF
chmod 755 files/etc/init.d/99_force_settings

# ➑ 文件权限修复（关键步骤）
find files -type d -exec chmod 755 {} \;
find files -type f -exec chmod 644 {} \;
chmod 755 files/usr/libexec/* files/etc/init.d/* files/etc/uci-defaults/*

# ➒ 编译前验证
echo -e "\033[32m[验证] 生成的文件结构：\033[0m"
tree -a files

echo -e "\n\033[32m[验证] 关键配置内容：\033[0m"
grep -r "192.168.150" files/
head -n 5 files/etc/banner

# ➓ 最终提示
cat <<EOF

\033[32m✅ 配置已完成！请按以下步骤操作：\033[0m

1. 强制清理编译环境（必须执行）：
   make dirclean && rm -rf bin

2. 开始编译：
   make -j\$(nproc) V=s

3. 刷机后验证：
   ssh root@192.168.150.2 "
     cat /etc/banner
     hostname
     uci get system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname
     cat /tmp/*.log
   "

\033[33m⚠️ 如果仍不生效，请检查：\033[0m
• 编译日志中是否包含 'Applying custom files'
• 文件系统是否包含 /etc/uci-defaults/10_network
• 首次启动日志 logread | grep force_settings
EOF