#!/bin/bash
# common.sh - 通用脚本
# 作者: 当贝AI助手
# 日期: 2025-03-19

# 设置 BUILD_PATH 为脚本所在目录的父目录（仓库根目录下的 scripts）
BUILD_PATH=$(dirname "$0")

# 加载 Diy_xinxi.sh 脚本，使用相对路径
source "${BUILD_PATH}/Diy_xinxi.sh"