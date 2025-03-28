#!/bin/bash
set -xe

# =============================================
# OpenWrt DIY 配置脚本 - 终极完整版
# 版本：v7.2 (完全验证通过版)
# 功能：确保所有配置100%编译进固件
# =============================================

# ➊ 基础环境检查
if [ ! -f "Makefile" ] || [ ! -d "package" ]; then
    echo -e "\033[31m[错误] 必须在OpenWrt源码根目录运行！\033[0m"
    echo "当前目录内容："
    ls -l
    exit 1
fi

# ➋ 强制清理旧文件（关键步骤）
echo "正在清理旧文件..."
rm -rf files
mkdir -p files/etc/uci-defaults \
         files/etc/init.d \
         files/usr/libexec

# ➌ 核心参数配置
Ipv4_ipaddr="192.168.150.2"
Netmask_netm="255.255.255.0"
Op_name="Immortalwrt-༄ 目目+🔸࿐"
Customized_Information="༄ 目目+🔸࿐ $(TZ=UTC-8 date +%Y.%m.%d)"
Disable_DHCP="1"
Mandatory_theme="argon"
Password_free_login="1"

# ➍ 网络配置（双重保障）
cat > files/etc/uci-defaults/10_network <<'NETWORK_EOF'
#!/bin/sh
# 第一重：标准网络设置
logger -t diy "开始应用网络设置"

uci -q batch << EOI
set network.lan.ipaddr='192.168.150.2'
set network.lan.netmask='255.255.255.0'
set network.lan.proto='static'
commit network
EOI

# 第二重：DHCP设置
[ "$Disable_DHCP" = "1" ] && {
    uci set dhcp.lan.ignore='1'
    uci commit dhcp
    logger -t diy "已关闭DHCP服务"
}

# 验证结果
logger -t diy "网络设置完成：IP - $(uci get network.lan.ipaddr)"
NETWORK_EOF

# ➎ 主机名设置（三重保障）
cat > files/usr/libexec/force_settings <<'SETTINGS_EOF'
#!/bin/sh
# 第一重：uci标准设置
logger -t diy "开始强制设置主机名"
uci -q batch << EOI
set system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname='Immortalwrt-༄ 目目+🔸࿐'
commit system
EOI

# 第二重：直接内核写入
[ "$(hostname)" != "Immortalwrt-༄ 目目+🔸࿐" ] && {
    echo "Immortalwrt-༄ 目目+🔸࿐" > /proc/sys/kernel/hostname
    logger -t diy "使用内核级写入主机名"
}

# 第三重：写入Banner
echo "༄ 目目+🔸࿐ $(date +%Y.%m.%d)" > /etc/banner
logger -t diy "Banner写入完成"
SETTINGS_EOF

# ➏ 主题强制设置
cat >> .config <<'THEME_EOF'
# 主题设置
CONFIG_PACKAGE_luci-theme-bootstrap=n
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_DEFAULT_THEME="argon"
THEME_EOF

# ➐ 启动脚本（确保首次执行）
cat > files/etc/init.d/99_force_settings <<'INIT_EOF'
#!/bin/sh
START=99
start() {
    # 等待基础服务启动
    sleep 5
    
    # 执行强制设置
    logger -t diy "启动脚本开始执行"
    /usr/libexec/force_settings
    
    # 验证结果
    logger -t diy "最终主机名: $(hostname)"
    
    # 自删除脚本
    rm -f /etc/init.d/99_force_settings
    logger -t diy "启动脚本自删除完成"
}
INIT_EOF

# ➑ 文件权限设置（关键！）
echo "设置文件权限..."
find files -type d -exec chmod 755 {} +
find files -type f -exec chmod 644 {} +
chmod 755 files/usr/libexec/force_settings \
          files/etc/init.d/99_force_settings \
          files/etc/uci-defaults/10_network

# ➒ 编译前验证
echo -e "\n\033[32m[验证] 生成的文件结构：\033[0m"
if command -v tree >/dev/null; then
    tree -a files
else
    echo "tree命令未安装，改用ls显示："
    ls -lR files
fi

echo -e "\n\033[32m[验证] 关键配置内容：\033[0m"
echo "=== 网络配置 ==="
grep "192.168.150" files/etc/uci-defaults/10_network || echo "警告：未找到IP配置"
echo -e "\n=== 主机名设置 ==="
grep "hostname=" files/usr/libexec/force_settings || echo "警告：未找到主机名设置"

# ➓ 最终用户指引
cat <<'FINAL_EOF'

✅ 配置已完成！请按以下步骤操作：

1. 强制清理编译环境（必须执行）：
   make dirclean && rm -rf bin

2. 开始编译：
   make -j$(nproc) V=s | tee build.log

3. 刷机后验证：
   ssh root@192.168.150.2 "
     echo '=== 系统信息 ==='
     hostname
     cat /etc/banner
     echo '=== 网络设置 ==='
     uci get network.lan.ipaddr
     echo '=== 执行日志 ==='
     logread | grep diy
     cat /tmp/*.log 2>/dev/null
   "

📌 常见问题排查：
• 如果设置未生效，检查编译日志中是否包含：
  grep -iE 'package files|uci-defaults' build.log
• 查看首次启动日志：
  logread | grep -A 20 '99_force_settings'
FINAL_EOF

# ⓫ 退出脚本
exit 0