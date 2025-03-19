#!/bin/bash
# common.sh - General utility script
# Purpose: Load Diy_xinxi.sh from the scripts directory

# Determine the directory of this script (scripts directory)
BUILD_PATH="$(dirname "$0")"

# Source Diy_xinxi.sh from the same directory as common.sh
source "${BUILD_PATH}/Diy_xinxi.sh"