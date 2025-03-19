#!/bin/bash
# common.sh - General utility script
# Purpose: Load Diy_xinxi.sh from the scripts directory

# Set BUILD_PATH to the directory containing this script (scripts/)
BUILD_PATH="$(dirname "$0")"

# Source Diy_xinxi.sh from the same directory
source "${BUILD_PATH}/Diy_xinxi.sh"