{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awww
    papirus-icon-theme
    adw-gtk3
    waypaper

    pavucontrol
    networkmanagerapplet
    nwg-drawer
    nwg-menu

    lf

    gthumb
    postman
    spotify
    zathura

    # Apps consolidated from single-file modules
    blender # 使用官方二進位快取預設版本（不加自訂 cudaSupport override）
    hmcl
    obsidian
    netease-cloud-music-gtk
    telegram-desktop
    tor-browser

    # Prisma
    prisma-engines

    # hypr
    wlr-randr # display management

    kitty

    libreoffice-stable
    mission-center # 系統監控工具 (GTK4/Libadwaita)
    google-antigravity # Antigravity 桌面版
    google-antigravity-cli # Antigravity CLI (agy)

    # Screenshot tools
    grim
    slurp
    swappy
    grimblast
    imagemagick
    libnotify

    openssl
    bitwig-studio

  ];

  programs.claude-code.enable = true;
}
