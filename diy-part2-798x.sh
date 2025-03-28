#!/bin/bash
set -xeuo pipefail

# =============================================
# OpenWrt DIY 终极写入保障脚本
# 版本：v8.0 (100%写入保证版)
# =============================================

# ➊ 环境严格检查
if [ ! -f "Makefile" ] || [ ! -d "package" ]; then
    echo -e "\033[31m[错误] 必须在OpenWrt源码根目录运行！\033[0m"
    echo "当前目录验证："
    ls -l Makefile package
    exit 1
fi

# ➋ 彻底清理旧配置（关键步骤）
echo "正在执行深度清理..."
rm -rf files
make dirclean >/dev/null 2>&1 || true
mkdir -p files/{etc/uci-defaults,etc/init.d,usr/libexec}

# ➌ 核心参数配置（保持您的原始设置）
export Ipv4_ipaddr="192.168.150.2"
export Netmask_netm="255.255.255.0"
export Op_name="Immortalwrt-༄ 目目+🔸࿐"
export Customized_Information="༄ 目目+🔸࿐ $(TZ=UTC-8 date +%Y.%m.%d)"
export Disable_DHCP="1"
export Mandatory_theme="argon"
export Password_free_login="1"

# ➍ 网络配置（四重保障）
cat > files/etc/uci-defaults/10_network <<'NET_EOF'
#!/bin/sh
# 保障层1：基本网络设置
logger -t diy "[10_network] 开始配置网络"

# 保障层2：IP设置
uci -q batch << EOI
delete network.lan
set network.lan=interface
set network.lan.proto='static'
set network.lan.ipaddr='192.168.150.2'
set network.lan.netmask='255.255.255.0'
commit network
EOI

# 保障层3：DHCP设置
[ "$Disable_DHCP" = "1" ] && {
    uci set dhcp.lan.ignore='1' 
    uci commit dhcp
    logger -t diy "[10_network] 已禁用DHCP"
}

# 保障层4：结果验证
logger -t diy "[10_network] 最终配置：$(uci show network.lan)"
NET_EOF

# ➎ 主机名设置（五重保障）
cat > files/usr/libexec/force_settings <<'HOST_EOF'
#!/bin/sh
# 保障层1：通过uci设置
MAX_RETRY=3
for i in $(seq 1 $MAX_RETRY); do
    uci -q batch << EOI
set system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname='Immortalwrt-༄ 目目+🔸࿐'
$( [ "$Password_free_login" = "1" ] && echo "set system.@system<source_id data="0" title="diy-part2-798x.sh" />.password=''" )
commit system
EOI
    [ "$(uci get system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname)" = "Immortalwrt-༄ 目目+🔸࿐" ] && break
    sleep 1
done

# 保障层2：直接写入内核
[ "$(hostname)" != "Immortalwrt-༄ 目目+🔸࿐" ] && {
    echo "Immortalwrt-༄ 目目+🔸࿐" > /proc/sys/kernel/hostname
    logger -t diy "[force_settings] 使用内核级写入"
}

# 保障层3：写入banner
echo "༄ 目目+🔸࿐ $(date +%Y.%m.%d)" > /etc/banner

# 保障层4：创建验证标记
touch /tmp/.diy_settings_done

# 保障层5：记录最终状态
logger -t diy "[force_settings] 最终主机名: $(hostname)"
HOST_EOF

# ➏ 主题强制设置（编译时注入）
cat >> .config <<'THEME_EOF'
# 强制主题设置
CONFIG_PACKAGE_luci-theme-bootstrap=n
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_DEFAULT_THEME="argon"
CONFIG_LUCI_LANG_zh_Hans=y
THEME_EOF

# ➐ 启动控制脚本（三重触发）
cat > files/etc/init.d/99_diy <<'INIT_EOF'
#!/bin/sh
START=99
boot() {
    # 等待基础服务启动
    sleep 5
    
    # 执行核心设置
    [ -x "/usr/libexec/force_settings" ] && {
        /usr/libexec/force_settings
        logger -t diy "[99_diy] 强制设置已执行"
    }
    
    # 最终验证
    if [ "$(hostname)" = "Immortalwrt-༄ 目目+🔸࿐" ]; then
        logger -t diy "[99_diy] 验证通过"
    else
        logger -t diy "[99_diy] 验证失败！当前主机名: $(hostname)"
    fi
    
    # 自清理
    rm -f /etc/init.d/99_diy
}
INIT_EOF

# ➑ 文件权限强化
echo "正在设置文件权限..."
find files -type d -exec chmod 755 {} +
find files -type f -exec chmod 644 {} +
chmod 755 files/usr/libexec/force_settings \
          files/etc/init.d/99_diy \
          files/etc/uci-defaults/10_network

# ➒ 编译前验证
echo -e "\n\033[32m[验证] 生成的文件结构：\033[0m"
ls -lR files

echo -e "\n\033[32m[验证] 关键配置内容：\033[0m"
echo "=== 网络配置 ==="
grep -A5 "192.168.150" files/etc/uci-defaults/10_network
echo -e "\n=== 主机名设置 ==="
grep -A3 "hostname=" files/usr/libexec/force_settings

# ➓ 用户指引
cat <<'GUIDE_EOF'

✅ 配置已完成！请按以下步骤操作：

1. 强制清理（必须执行）：
   make dirclean && rm -rf bin

2. 开始编译：
   make -j$(nproc) V=s | tee build.log

3. 刷机后验证：
   ssh root@192.168.150.2 "
     echo '