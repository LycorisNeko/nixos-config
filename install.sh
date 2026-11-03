#!/usr/bin/env bash
set -e

# ANSI 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=======================================${NC}"
echo -e "${BLUE}  NixOS 一键配置部署脚本 (install.sh)   ${NC}"
echo -e "${BLUE}=======================================${NC}"

# 获取脚本所在根目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 1. 检查并复制硬件配置
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    echo -e "${GREEN}[1/3] 正在同步硬件配置文件...${NC}"
    cp /etc/nixos/hardware-configuration.nix ./hardware-configuration.nix
    echo -e "  已从 /etc/nixos/hardware-configuration.nix 复制到当前仓库。"
else
    echo -e "${YELLOW}[警告] 未在 /etc/nixos/ 中找到 hardware-configuration.nix。${NC}"
    if [ -f "./hardware-configuration.nix" ]; then
        echo -e "  将使用仓库内现有的 hardware-configuration.nix。"
    else
        echo -e "${RED}[错误] 未找到任何有效的 hardware-configuration.nix，构建中止！${NC}"
        exit 1
    fi
fi

# 2. 将修改暂存到 Git (Nix Flakes 仅读取被 Git 跟踪的文件)
echo -e "${GREEN}[2/3] 暂存配置到 Git...${NC}"
git add -A
echo -e "  所有配置文件已暂存。"

# 3. 执行系统级构建
echo -e "${GREEN}[3/3] 开始执行 nixos-rebuild switch...${NC}"
echo -e "${YELLOW}提示: 如果提示密码，请输入当前用户的 sudo 密码。${NC}"
sudo nixos-rebuild switch --flake .#

echo -e "${GREEN}=======================================${NC}"
echo -e "${GREEN}  NixOS 系统部署完成！                  ${NC}"
echo -e "${GREEN}=======================================${NC}"
echo -e "你可以重启电脑享受全新的桌面环境："
echo -e "  ${BLUE}systemctl reboot${NC}"
