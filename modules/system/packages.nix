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
    libndctl
    docker-compose
    wl-clipboard
    playerctl
    xdg-utils
    tree
    ntfs3g
    dosfstools
    hyprpolkitagent
    visidata

    # 遊戲轉譯層
    protonup-qt # Proton 版本管理工具

  ];

  # 啟用 nix-ld 以運行通用動態鏈接 Linux 二進位檔（如 curl 下載的 agy 等 CLI/未打包原生程式）
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      curl
      glibc
      libgcc
      util-linux
    ];
  };
}
