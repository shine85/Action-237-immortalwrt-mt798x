#!/bin/bash
# Diy_xinxi.sh - Custom compilation information script

# Use GITHUB_WORKSPACE if BUILD_PATH is not set
BUILD_PATH="${BUILD_PATH:-$GITHUB_WORKSPACE/scripts}"

# Define output file
BUILD_INFO_FILE="${BUILD_PATH}/build_info.txt"

# Extract information from .config
KERNEL_VERSION=$(grep '^LINUX_VERSION' .config | cut -d '=' -f 2 | tr -d '"')
TARGET_DEVICE=$(grep '^CONFIG_TARGET_BOARD' .config | cut -d '=' -f 2 | tr -d '"')
BUILD_TIME=$(date "+%Y-%m-%d %H:%M:%S")
BUILD_USER=$(whoami)
BUILD_HOST=$(hostname)

# Get enabled packages
ENABLED_PLUGINS=$(grep '^CONFIG_PACKAGE_' .config | grep '=y$' | cut -d '=' -f 1 | sed 's/CONFIG_PACKAGE_//')

# Write to build info file
echo "===== Compilation Information =====" > "$BUILD_INFO_FILE"
echo "Firmware Version: ImmortalWrt MT7981" >> "$BUILD_INFO_FILE"
echo "Kernel Version: $KERNEL_VERSION" >> "$BUILD_INFO_FILE"
echo "Target Device: $TARGET_DEVICE" >> "$BUILD_INFO_FILE"
echo "Build Time: $BUILD_TIME" >> "$BUILD_INFO_FILE"
echo "Build User: $BUILD_USER" >> "$BUILD_INFO_FILE"
echo "Build Host: $BUILD_HOST" >> "$BUILD_INFO_FILE"
echo "===================" >> "$BUILD_INFO_FILE"
echo "===== Enabled Plugins =====" >> "$BUILD_INFO_FILE"
echo "$ENABLED_PLUGINS" >> "$BUILD_INFO_FILE"
echo "===================" >> "$BUILD_INFO_FILE"

# Display the information
cat "$BUILD_INFO_FILE"

# Check for success
if [ $? -eq 0 ]; then
  echo "Compilation information generated successfully!"
else
  echo "Failed to generate compilation information!"
  exit 1
fi