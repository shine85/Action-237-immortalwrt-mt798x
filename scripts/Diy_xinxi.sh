#!/bin/bash
# 自定义编译信息脚本 - Custom compilation information script

# 设置构建路径 - Set build path
# 如果 BUILD_PATH 未设置，则使用 GITHUB_WORKSPACE/scripts - Use GITHUB_WORKSPACE/scripts if BUILD_PATH is not set
BUILD_PATH="${BUILD_PATH:-$GITHUB_WORKSPACE/scripts}"

# 定义输出文件 - Define output file
BUILD_INFO_FILE="${BUILD_PATH}/build_info.txt" # 构建信息文件路径 - Build information file path

# 从 .config 中提取信息 - Extract information from .config
KERNEL_VERSION=$(grep '^LINUX_VERSION' .config | cut -d '=' -f 2 | tr -d '"') # 内核版本 - Kernel version
TARGET_DEVICE=$(grep '^CONFIG_TARGET_BOARD' .config | cut -d '=' -f 2 | tr -d '"') # 目标设备 - Target device
BUILD_TIME=$(date "+%Y-%m-%d %H:%M:%S") # 构建时间 - Build time
BUILD_USER=$(whoami) # 构建用户 - Build user
BUILD_HOST=$(hostname) # 构建主机 - Build host

# 获取已启用的插件 - Get enabled packages
ENABLED_PLUGINS=$(grep '^CONFIG_PACKAGE_' .config | grep '=y$' | cut -d '=' -f 1 | sed 's/CONFIG_PACKAGE_//') # 已启用插件列表 - List of enabled plugins

# 写入构建信息文件 - Write to build info file
echo "===== 编译信息 =====" > "$BUILD_INFO_FILE" # 编译信息标题 - Compilation information header
echo "固件版本: ImmortalWrt MT7981" >> "$BUILD_INFO_FILE" # 固件版本 - Firmware version
echo "内核版本: $KERNEL_VERSION" >> "$BUILD_INFO_FILE" # 内核版本 - Kernel version
echo "目标设备: $TARGET_DEVICE" >> "$BUILD_INFO_FILE" # 目标设备 - Target device
echo "构建时间: $BUILD_TIME" >> "$BUILD_INFO_FILE" # 构建时间 - Build time
echo "构建用户: $BUILD_USER" >> "$BUILD_INFO_FILE" # 构建用户 - Build user
echo "构建主机: $BUILD_HOST" >> "$BUILD_INFO_FILE" # 构建主机 - Build host
echo "===================" >> "$BUILD_INFO_FILE" # 分隔线 - Separator

# 添加已启用插件信息 - Add enabled plugins information
echo "===== 已启用插件 =====" >> "$BUILD_INFO_FILE" # 已启用插件标题 - Enabled plugins header
echo "$ENABLED_PLUGINS" >> "$BUILD_INFO_FILE" # 插件列表 - Plugins list
echo "===================" >> "$BUILD_INFO_FILE" # 分隔线 - Separator

# 显示信息 - Display the information
cat "$BUILD_INFO_FILE" # 输出文件内容到控制台 - Output file content to console

# 检查执行结果 - Check for success
if [ $? -eq 0 ]; then
  echo "编译信息生成成功！" # 成功提示 - Success message
else
  echo "编译信息生成失败！" # 失败提示 - Failure message
  exit 1 # 退出并返回错误码 - Exit with error code
fi