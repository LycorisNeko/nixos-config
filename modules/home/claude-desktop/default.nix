{ pkgs, ... }:
{
  home.packages = with pkgs; [
    claude-desktop
  ];

  # 針對 Niri/Wayland 與 Fcitx5 環境配置 Claude Desktop 桌面啟動方式
  xdg.desktopEntries."com.anthropic.Claude" = {
    name = "Claude";
    genericName = "AI Assistant";
    # 強制 Electron 讀取 Wayland 並啟用 text-input-v3 以正常使用 fcitx5 輸入法
    exec = "claude-desktop --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-wayland-ime %U";
    icon = "claude-desktop";
    comment = "Desktop application for Claude.ai";
    categories = [
      "Utility"
      "Development"
    ];
    terminal = false;
    type = "Application";
    mimeType = [ "x-scheme-handler/claude" ];
    settings = {
      StartupWMClass = "com.anthropic.Claude";
    };
    actions = {
      "NewChat" = {
        name = "New Chat";
        exec = "claude-desktop --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-wayland-ime \"claude://claude.ai/new?surface=chat&source=desktop_action\"";
      };
      "NewCode" = {
        name = "New Claude Code Session";
        exec = "claude-desktop --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,UseOzonePlatform --enable-wayland-ime \"claude://code/new?source=desktop_action\"";
      };
    };
  };

  # 關聯 URL Scheme，允許由瀏覽器或外部應用程式呼叫 claude://
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/claude" = [ "com.anthropic.Claude.desktop" ];
  };
}
