#!/bin/bash
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
# DIY扩展二合一了，在此处可以增加插件
# 自行拉取插件之前请SSH连接进入固件配置里面确认过没有你要的插件再单独拉取你需要的插件
# 不要一下就拉取别人一个插件包N多插件的，多了没用，增加编译错误，自己需要的才好

# 克隆插件
git clone https://github.com/nikkinikki-org/OpenWrt-nikki package/Nikki
git clone https://github.com/281677160/luci-app-autoupdate package/autoupdate

# 后台IP设置
export Ipv4_ipaddr="192.168.150.2"            # 修改openwrt后台地址(填0为关闭)
export Netmask_netm="255.255.255.0"         # IPv4 子网掩码（默认：255.255.255.0）(填0为不作修改)
export Op_name="༄ 目目+࿐"                # 修改主机名称为OpenWrt-123(填0为不作修改)
echo "CONFIG_IPV4_ADDR=\"$Ipv4_ipaddr\"" >> .config
echo "CONFIG_NETMASK_NETM=\"$Netmask_netm\"" >> .config
echo "CONFIG_OP_NAME=\"$Op_name\"" >> .config

# 内核和系统分区大小(不是每个机型都可用)
export Kernel_partition_size="0"            # 内核分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般16,数值以MB计算，填0为不作修改),如果你不懂就填0
export Rootfs_partition_size="0"            # 系统分区大小,每个机型默认值不一样 (填写您想要的数值,默认一般300左右,数值以MB计算，填0为不作修改),如果你不懂就填0
echo "CONFIG_KERNEL_PARTITION_SIZE=\"$Kernel_partition_size\"" >> .config
echo "CONFIG_ROOTFS_PARTITION_SIZE=\"$Rootfs_partition_size\"" >> .config

# 默认主题设置
export Mandatory_theme="argon"              # 将bootstrap替换您需要的主题为必选主题(可自行更改您要的,源码要带此主题就行,填写名称也要写对) (填写主题名称,填0为不作修改)
export Default_theme="argon"                # 多主题时,选择某主题为默认第一主题 (填写主题名称,填0为不作修改)
echo "CONFIG_MANDATORY_THEME=\"$Mandatory_theme\"" >> .config
echo "CONFIG_DEFAULT_THEME=\"$Default_theme\"" >> .config

# 旁路由选项
export Gateway_Settings="192.168.150.1"                 # 旁路由设置 IPv4 网关(填入您的网关IP为启用)(填0为不作修改)
export DNS_Settings="192.168.151.2 223.5.5.5"                     # 旁路由设置 DNS(填入DNS，多个DNS要用空格分开)(填0为不作修改)
export Broadcast_Ipv4="0"                   # 设置 IPv4 广播(填入您的IP为启用)(填0为不作修改)
export Disable_DHCP="1"                     # 旁路由关闭DHCP功能(1为启用命令,填0为不作修改)
export Disable_Bridge="1"                   # 旁路由去掉桥接模式(1为启用命令,填0为不作修改)
export Create_Ipv6_Lan="0"                  # 爱快+OP双系统时,爱快接管IPV6,在OP创建IPV6的lan口接收IPV6信息(1为启用命令,填0为不作修改)
echo "CONFIG_GATEWAY_SETTINGS=\"$Gateway_Settings\"" >> .config
echo "CONFIG_DNS_SETTINGS=\"$DNS_Settings\"" >> .config
echo "CONFIG_BROADCAST_IPV4=\"$Broadcast_Ipv4\"" >> .config
echo "CONFIG_DISABLE_DHCP=\"$Disable_DHCP\"" >> .config
echo "CONFIG_DISABLE_BRIDGE=\"$Disable_Bridge\"" >> .config
echo "CONFIG_CREATE_IPV6_LAN=\"$Create_Ipv6_Lan\"" >> .config

# IPV6、IPV4 选择
export Enable_IPV6_function="0"             # 编译IPV6固件(1为启用命令,填0为不作修改)(如果跟Create_Ipv6_Lan一起启用命令的话,Create_Ipv6_Lan命令会自动关闭)
export Enable_IPV4_function="0"             # 编译IPV4固件(1为启用命令,填0为不作修改)(如果跟Enable_IPV6_function一起启用命令的话,此命令会自动关闭)
echo "CONFIG_ENABLE_IPV6_FUNCTION=\"$Enable_IPV6_function\"" >> .config
echo "CONFIG_ENABLE_IPV4_FUNCTION=\"$Enable_IPV4_function\"" >> .config

# 替换OpenClash的源码(默认master分支)
export OpenClash_branch="0"                 # OpenClash的源码分别有【master分支】和【dev分支】(填0为使用master分支,填1为使用dev分支)
echo "CONFIG_OPENCLASH_BRANCH=\"$OpenClash_branch\"" >> .config

# 个性签名,默认增加年月日[$(TZ=UTC-8 date "+%Y.%m.%d")]
export Customized_Information="༄ 目目+࿐$(TZ=UTC-8 date "+%Y.%m.%d")"  # 个性签名,你想写啥就写啥，(填0为不作修改)
echo "CONFIG_CUSTOMIZED_INFORMATION=\"$Customized_Information\"" >> .config

# 更换固件内核
export Replace_Kernel="0"                    # 更换内核版本,在对应源码的[target/linux/架构]查看patches-x.x,看看x.x有啥就有啥内核了(填入内核x.x版本号,填0为不作修改)
echo "CONFIG_REPLACE_KERNEL=\"$Replace_Kernel\"" >> .config

# 设置免密码登录(个别源码本身就没密码的)
export Password_free_login="1"               # 设置首次登录后台密码为空（进入openwrt后自行修改密码）(1为启用命令,填0为不作修改)
echo "CONFIG_PASSWORD_FREE_LOGIN=\"$Password_free_login\"" >> .config

# 增加AdGuardHome插件和核心
export AdGuardHome_Core="0"                  # 编译固件时自动增加AdGuardHome插件和AdGuardHome插件核心,需要注意的是一个核心20多MB的,小闪存机子搞不来(1为启用命令,填0为不作修改)
echo "CONFIG_ADGUARDHOME_CORE=\"$AdGuardHome_Core\"" >> .config

# 禁用ssrplus和passwall的NaiveProxy
export Disable_NaiveProxy="0"                # 因个别源码的分支不支持编译NaiveProxy,不小心选择了就编译错误了,为减少错误,打开这个选项后,就算选择了NaiveProxy也会把NaiveProxy干掉不进行编译的(1为启用命令,填0为不作修改)
echo "CONFIG_DISABLE_NAIVEPROXY=\"$Disable_NaiveProxy\"" >> .config

# 开启NTFS格式盘挂载
export Automatic_Mount_Settings="0"          # 编译时加入开启NTFS格式盘挂载的所需依赖(1为启用命令,填0为不作修改)
echo "CONFIG_AUTOMATIC_MOUNT_SETTINGS=\"$Automatic_Mount_Settings\"" >> .config

# 去除网络共享(autosamba)
export Disable_autosamba="1"                 # 去掉源码默认自选的luci-app-samba或luci-app-samba4(1为启用命令,填0为不作修改)
echo "CONFIG_DISABLE_AUTOSAMBA=\"$Disable_autosamba\"" >> .config

# 其他
export Ttyd_account_free_login="0"           # 设置ttyd免密登录(1为启用命令,填0为不作修改)
export Delete_unnecessary_items="0"          # 个别机型内一堆其他机型固件,删除其他机型的,只保留当前主机型固件(1为启用命令,填0为不作修改)
export Disable_53_redirection="0"            # 删除DNS强制重定向53端口防火墙规则(个别源码本身不带此功能)(1为启用命令,填0为不作修改)
export Cancel_running="0"                    # 取消路由器每天跑分任务(个别源码本身不带此功能)(1为启用命令,填0为不作修改)
echo "CONFIG_TTYD_ACCOUNT_FREE_LOGIN=\"$Ttyd_account_free_login\"" >> .config
echo "CONFIG_DELETE_UNNECESSARY_ITEMS=\"$Delete_unnecessary_items\"" >> .config
echo "CONFIG_DISABLE_53_REDIRECTION=\"$Disable_53_redirection\"" >> .config
echo "CONFIG_CANCEL_RUNNING=\"$Cancel_running\"" >> .config

# 晶晨CPU系列打包固件设置(不懂请看说明)
export amlogic_model="s905d"
export amlogic_kernel="5.10.01_6.1.01"
export auto_kernel="true"
export rootfs_size="2560"
export kernel_usage="stable"
echo "CONFIG_AMLOGIC_MODEL=\"$amlogic_model\"" >> .config
echo "CONFIG_AMLOGIC_KERNEL=\"$amlogic_kernel\"" >> .config
echo "CONFIG_AUTO_KERNEL=\"$auto_kernel\"" >> .config
echo "CONFIG_ROOTFS_SIZE=\"$rootfs_size\"" >> .config
echo "CONFIG_KERNEL_USAGE=\"$kernel_usage\"" >> .config

# 修改插件名字
find ./ -type f -exec sed -i 's/"终端"/"终端TTYD"/g' {} +
find ./ -type f -exec sed -i 's/"网络存储"/"NAS"/g' {} +
find ./ -type f -exec sed -i 's/"实时流量监测"/"流量"/g' {} +
find ./ -type f -exec sed -i 's/"KMS 服务器"/"KMS激活"/g' {} +
find ./ -type f -exec sed -i 's/"USB 打印服务器"/"打印服务"/g' {} +
find ./ -type f -exec sed -i 's/"Web 管理"/"Web管理"/g' {} +
find ./ -type f -exec sed -i 's/"管理权"/"管理权"/g' {} +
find ./ -type f -exec sed -i 's/"带宽监控"/"带宽监控"/g' {} +

# 整理固件包时候,删除您不想要的固件或者文件,让它不需要上传到Actions空间(根据编译机型变化,自行调整删除名称)
CLEAR_PATH="./clear_list.txt"
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

# 在线更新时，删除不想保留固件的某个文件，在EOF跟EOF之间加入删除代码，记住这里对应的是固件的文件路径，比如： rm -rf /etc/config/luci
DELETE="./delete_list.txt"
cat >>"$DELETE" <<-EOF
EOF