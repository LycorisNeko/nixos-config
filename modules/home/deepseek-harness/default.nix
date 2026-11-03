{ inputs, pkgs, ... }:
{
  imports = [
    inputs.deepseek-harness.homeModules.default
  ];

  programs.dsh = {
    enable = true;
    desktop.enable = true;
  };

  # 針對 Niri/Wayland 與 Fcitx5 環境配置 DeepSeek Harness Desktop 桌面啟動方式
  xdg.desktopEntries."deepseek-ai-dsh-desktop" = {
    name = "DeepSeek Harness";
    genericName = "AI Assistant & Agent Harness";
    # 強制 Electron 讀取 Wayland 並啟用 text-input-v3 以正常使用 fcitx5 輸入法
    exec = "dsh-desktop --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-wayland-ime %U";
    icon = "deepseek-ai-dsh-desktop";
    comment = "Desktop application for DeepSeek Harness";
    categories = [
      "Utility"
      "Development"
    ];
    terminal = false;
    type = "Application";
    settings = {
      StartupWMClass = "deepseek-ai-dsh-desktop";
    };
  };
}
