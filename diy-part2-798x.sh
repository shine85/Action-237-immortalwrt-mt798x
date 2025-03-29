#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了,在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的,多了没用,增加编译错误,自己需要的才好
git clone https://github.com/nikkinikki-org/OpenWrt-nikki package/Nikki
git clone https://github.com/281677160/luci-app-autoupdate package/autoupdate

# 后台IP设置
export Ipv4_ipaddr="192.168.150.2"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码(默认:255.255.255.0)(填0为不作修改)
export Op_name="༄ 目目+࿐"                # 修改主机名称为OpenWrt-123(填0为不作修改)

# 内核和系统分区大小(不是每个机型都可用)
export Kernel_partition_size="0"            # 内核分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般16,数值以MB计算,填0为不作修改),如果你不懂就填0
export Rootfs_partition_size="0"            # 系统分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般300左右,数值以MB计算,填0为不作修改),如果你不懂就填0

# 默认主题设置
export Mandatory_theme="argon"              # 将bootstrap替换您需要的主题为必选主题(可自行更改您要的,源码要带此主题就行,填写名称也要写对) (填写主题名称,填0为不作修改)
export Default_theme="argon"                # 多主题时,选择某主题为默认第一主题 (填写主题名称,填0为不作修改)

# 旁路由选项
export Gateway_Settings="192.168.150.1"                 # 旁路由设置 IPv4 网关(填入您的网关IP为启用)(填0为不作修改)
export DNS_Settings="192.168.151.2 223.5.5.5"                     # 旁路由设置 DNS(填入DNS,多个DNS要用空格分开)(填0为不作修改)
export Broadcast_Ipv4="0"                   # 设置 IPv4 广播(填入您的IP为启用)(填0为不作修改)
export Disable_DHCP="1"                     # 旁路由关闭DHCP功能(1为启用命令,填0为不作修改)
export Disable_Bridge="1"                   # 旁路由去掉桥接模式(1为启用命令,填0为不作修改)
export Create_Ipv6_Lan="0"                  # 爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息(1为启用命令,填0为不作修改)

# IPV6、IPV4 选择
export Enable_IPV6_function="0"             # 编译IPV6固件(1为启用命令,填0为不作修改)(如果跟Create_Ipv6_Lan一起启用命令的话,Create_Ipv6_Lan命令会自动关闭)
export Enable_IPV4_function="0"             # 编译IPV4固件(1为启用命令,填0为不作修改)(如果跟Enable_IPV6_function一起启用命令的话,此命令会自动关闭)

# 替换OpenClash的源码(默认master分支)
export OpenClash_branch="0"                 # OpenClash的源码分别有【master分支】和【dev分支】(填0为使用master分支,填1为使用dev分支)

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
export Customized_Information="༄ 目目+࿐$(TZ=UTC-8 date "+%Y.%m.%d")"  # 个性签名,你想写啥就写啥,(填0为不作修改)

# 更换固件内核
export Replace_Kernel="0"                    # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核x.x版本号,填0为不作修改)

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="1"               # 设置首次登录后台密码为空(进入openwrt后自行修改密码)(1为启用命令,填0为不作修改)

# 增加AdGuardHome插件和核心
export AdGuardHome_Core="0"                  # 编译固件时自动增加AdGuardHome插件和AdGuardHome插件核心,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不作修改)

# 禁用ssrplus和passwall的NaiveProxy
export Disable_NaiveProxy="0"                # 因个别源码的分支不支持编译NaiveProxy,不小心选择了就编译错误了,为减少错误,打开这个选项后,就算选择了NaiveProxy也会把NaiveProxy干掉不进行编译的(1为启用命令,填0为不作修改)

# 开启NTFS格式盘挂载
export Automatic_Mount_Settings="0"          # 编译时加入开启NTFS格式盘挂载的所需依赖(1为启用命令,填0为不作修改)

# 去除网络共享(autosamba)
export Disable_autosamba="1"                 # 去掉源码默认自选的luci-app-samba或luci-app-samba4(1为启用命令,填0为不作修改)

# 其他
export Ttyd_account_free_login="0"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
export Delete_unnecessary_items="0"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
export Disable_53_redirection="0"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带此功能)(1为启用命令,填0为不作修改)
export Cancel_running="0"                    # 取消路由器每天跑分任务(个别源码本身不带此功能)(1为启用命令,填0为不作修改)

# 晶晨CPU系列打包固件设置(不懂请看说明)
export amlogic_model="s905d"
export amlogic_kernel="5.10.01_6.1.01"
export auto_kernel="true"
export rootfs_size="2560"
export kernel_usage="stable"

# 将导出的变量实际应用到OpenWrt配置中
echo "开始应用自定义配置..."

# 创建自定义配置脚本
mkdir -p package/base-files/files/etc/uci-defaults
touch package/base-files/files/etc/uci-defaults/99-custom-settings
chmod +x package/base-files/files/etc/uci-defaults/99-custom-settings

# 应用IP地址设置
if [ "$Ipv4_ipaddr" != "0" ]; then
  echo "设置后台IP为 $Ipv4_ipaddr"
  sed -i "s/192.168.1.1/$Ipv4_ipaddr/g" package/base-files/files/bin/config_generate
fi

if [ "$Netmask_netm" != "0" ]; then
  echo "设置子网掩码为 $Netmask_netm"
  sed -i "s/255.255.255.0/$Netmask_netm/g" package/base-files/files/bin/config_generate
fi

if [ "$Op_name" != "0" ]; then
  echo "设置主机名为 $Op_name"
  sed -i "s/ImmortalWrt/$Op_name/g" package/base-files/files/bin/config_generate
  # 备用方法，如果上面的替换失败
  echo "uci set system.@system<source_id data="0" title="diy-part2-798x.sh" />.hostname='$Op_name'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit system" >> package/base-files/files/etc/uci-defaults/99-custom-settings
fi

# 应用主题设置
if [ "$Mandatory_theme" != "0" ] && [ -d "feeds/luci/collections/luci" ]; then
  echo "设置必选主题为 $Mandatory_theme"
  sed -i "s/luci-theme-bootstrap/luci-theme-$Mandatory_theme/g" feeds/luci/collections/luci/Makefile
fi

if [ "$Default_theme" != "0" ]; then
  echo "设置默认主题为 $Default_theme"
  echo "uci set luci.main.mediaurlbase='/luci-static/$Default_theme'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit luci" >> package/base-files/files/etc/uci-defaults/99-custom-settings
fi

# 应用旁路由设置
if [ "$Disable_DHCP" == "1" ]; then
  echo "禁用DHCP服务"
  echo "uci set dhcp.lan.ignore='1'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit dhcp" >> package/base-files/files/etc/uci-defaults/99-custom-settings
fi

if [ "$Gateway_Settings" != "0" ]; then
  echo "设置旁路由网关为 $Gateway_Settings"
  echo "uci set network.lan.gateway='$Gateway_Settings'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit network" >> package/base-files/files/etc/uci-defaults/99-custom-settings
fi

if [ "$DNS_Settings" != "0" ]; then
  echo "设置DNS为 $DNS_Settings"
  echo "uci set network.lan.dns='$DNS_Settings'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit network" >> package/base-files/files/etc/uci-defaults/99-custom-settings
fi

if [ "$Disable_Bridge" == "1" ]; then
  echo "禁用桥接模式"
  echo "uci set network.lan.type='static'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit network" >> package/base-files/files/etc/uci-defaults/99-custom-settings
fi

# 密码设置
if [ "$Password_free_login" == "1" ]; then
  echo "设置免密码登录"
  sed -i '/root:/d' package/base-files/files/etc/shadow 2>/dev/null || true
  mkdir -p package/base-files/files/etc/
  touch package/base-files/files/etc/shadow
  echo "root::0:0:99999:7:::" >> package/base-files/files/etc/shadow
fi

# 添加自定义信息到固件
if [ "$Customized_Information" != "0" ]; then
  echo "添加个性签名: $Customized_Information"
  mkdir -p package/base-files/files/etc/
  echo "$Customized_Information" > package/base-files/files/etc/customized_information
  if [ -f "package/base-files/files/etc/rc.local" ]; then
    sed -i '/exit 0/d' package/base-files/files/etc/rc.local
    echo "echo \"\$(cat /etc/customized_information 2>/dev/null)\" >> /etc/banner" >> package/base-files/files/etc/rc.local
    echo "exit 0" >> package/base-files/files/etc/rc.local
  else
    mkdir -p package/base-files/files/etc/
    echo "#!/bin/sh" > package/base-files/files/etc/rc.local
    echo "echo \"\$(cat /etc/customized_information 2>/dev/null)\" >> /etc/banner" >> package/base-files/files/etc/rc.local
    echo "exit 0" >> package/base-files/files/etc/rc.local
    chmod +x package/base-files/files/etc/rc.local
  fi
fi

# 应用IPV6/IPV4设置
if [ "$Enable_IPV6_function" == "1" ]; then
  echo "启用IPV6功能"
  echo "uci set network.lan.ipv6='1'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci set network.wan.ipv6='1'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci set dhcp.lan.ra='server'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci set dhcp.lan.dhcpv6='server'" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit network" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit dhcp" >> package/base-files/files/etc/uci-defaults/99-custom-settings
fi

# 禁用网络共享
if [ "$Disable_autosamba" == "1" ]; then
  echo "禁用自动Samba"
  # 创建/修改配置文件
  mkdir -p package/base-files/files/etc/uci-defaults/
  cat << EOF >> package/base-files/files/etc/uci-defaults/99-disable-samba
#!/bin/sh
# 禁用Samba服务
uci delete samba.@samba<source_id data="0" title="diy-part2-798x.sh" /> 2>/dev/null || true
uci commit
/etc/init.d/samba stop 2>/dev/null || true
/etc/init.d/samba disable 2>/dev/null || true
exit 0
EOF
  chmod +x package/base-files/files/etc/uci-defaults/99-disable-samba
  
  # 尝试从.config中删除Samba (如果存在)
  if [ -f ".config" ]; then
    sed -i '/CONFIG_PACKAGE_autosamba/d' .config 2>/dev/null || true
    sed -i '/CONFIG_PACKAGE_luci-app-samba/d' .config 2>/dev/null || true
    sed -i '/CONFIG_PACKAGE_luci-app-samba4/d' .config 2>/dev/null || true
    echo "# CONFIG_PACKAGE_autosamba is not set" >> .config
    echo "# CONFIG_PACKAGE_luci-app-samba is not set" >> .config
    echo "# CONFIG_PACKAGE_luci-app-samba4 is not set" >> .config
  fi
fi

# 修改ttyd免密登录
if [ "$Ttyd_account_free_login" == "1" ]; then
  echo "设置ttyd免密登录"
  echo "sed -i 's/login/login -f root/g' /etc/config/ttyd" >> package/base-files/files/etc/uci-defaults/99-custom-settings
  echo "uci commit ttyd" >> package/base-files/files/etc/uci-defaults/99-custom-settings
fi

# 修改插件名字
echo "修改插件名称..."
find_and_replace() {
  local search="$1"
  local replace="$2"
  # 查找可能包含匹配文本的所有 .po .lua .htm .js 文件
  local files=$(find . -type f \( -name "*.po" -o -name "*.lua" -o -name "*.htm" -o -name "*.js" \) | xargs grep -l "$search" 2>/dev/null || true)
  
  if [ -n "$files" ]; then
    echo "修改 '$search' 为 '$replace'"
    for file in $files; do
      sed -i "s/$search/$replace/g" "$file" 2>/dev/null || true
    done
  else
    echo "未找到包含 '$search' 的文件，跳过替换"
  fi
}

# 应用插件名替换
find_and_replace "终端" "终端TTYD"
find_and_replace "网络存储" "NAS"
find_and_replace "实时流量监测" "流量"
find_and_replace "KMS 服务器" "KMS激活"
find_and_replace "USB 打印服务器" "打印服务"
find_and_replace "Web 管理" "Web管理"
find_and_replace "管理权" "管理权"
find_and_replace "带宽监控" "带宽监控"

# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
CLEAR_PATH="$(pwd)/Clear_PATH.sh"
cat >"$CLEAR_PATH" <<-EOF
packages
config.buildinfo
feeds.buildinfo
sha256sums
version.buildinfo
profiles.json
openwrt-mt798x-*-rootfs.tar.gz
EOF

# 在线更新时,删除不想保留固件的某个文件,在EOF跟EOF之间加入删除代码,记住这里对应的是固件的文件路径,比如: rm -rf /etc/config/luci
DELETE="$(pwd)/Delete.sh"
cat >$DELETE <<-EOF
EOF

echo "完成应用自定义配置"