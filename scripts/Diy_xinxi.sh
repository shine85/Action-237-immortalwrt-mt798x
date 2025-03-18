#!/bin/bash
# Diy_xinxi - 自定义编译信息脚本
# 作者: 当贝AI助手
# 日期: 2025-03-18

# 设置变量
BUILD_INFO_FILE="${BUILD_PATH}/build_info.txt"
KERNEL_VERSION=$(grep '^LINUX_VERSION' .config | cut -d '=' -f 2 | tr -d '"')
TARGET_DEVICE=$(grep '^CONFIG_TARGET_BOARD' .config | cut -d '=' -f 2 | tr -d '"')
BUILD_TIME=$(date "+%Y-%m-%d %H:%M:%S")
BUILD_USER=$(whoami)
BUILD_HOST=$(hostname)

# 提取已启用的插件信息
ENABLED_PLUGINS=$(grep '^CONFIG_PACKAGE_' .config | grep '=y$' | cut -d '=' -f 1 | sed 's/CONFIG_PACKAGE_//')

# 创建编译信息文件
echo "===== 编译信息 =====" > "$BUILD_INFO_FILE"
echo "固件版本: ImmortalWrt MT7981" >> "$BUILD_INFO_FILE"
echo "内核版本: $KERNEL_VERSION" >> "$BUILD_INFO_FILE"
echo "目标设备: $TARGET_DEVICE" >> "$BUILD_INFO_FILE"
echo "编译时间: $BUILD_TIME" >> "$BUILD_INFO_FILE"
echo "编译用户: $BUILD_USER" >> "$BUILD_INFO_FILE"
echo "编译主机: $BUILD_HOST" >> "$BUILD_INFO_FILE"
echo "===================" >> "$BUILD_INFO_FILE"

# 添加插件信息
echo "===== 已启用插件 =====" >> "$BUILD_INFO_FILE"
echo "$ENABLED_PLUGINS" >> "$BUILD_INFO_FILE"
echo "===================" >> "$BUILD_INFO_FILE"

# 输出编译信息到控制台
cat "$BUILD_INFO_FILE"

# 检查编译状态
if [ $? -eq 0 ]; then
  echo "编译信息生成成功！"
else
  echo "编译信息生成失败！"
  exit 1
fi