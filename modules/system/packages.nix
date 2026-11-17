{ pkgs, ... }:
{
  # Enable Java and set JAVA_HOME automatically
  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
    # Android tools (adb, fastboot等，systemd 258+ 自动处理 uaccess 规则)
    android-tools
    # Git HTTPS 凭据通过 GNOME Keyring 安全保存，不写入明文文件。
    gitFull
    gnome-keyring

    # Core utils
    wget
    vim
    curl
    unzip
    zip
    btop
    python3
    ffmpeg
    pciutils
    nvtopPackages.nvidia

    docker-compose

    wl-clipboard
    playerctl
    xdg-utils
    tree
    ntfs3g
    dosfstools
    hyprpolkitagent

    # 傲腾持久内存 (Intel Optane PMEM) 管理工具
    ndctl   # nvdimm/pmem 命名空间管理（ndctl list / ndctl create-namespace）
    ipmctl  # 傲腾固件更新与健康监测

    visidata

    # 遊戲轉譯層
    protonup-qt # Proton 版本管理工具

  ];
}
