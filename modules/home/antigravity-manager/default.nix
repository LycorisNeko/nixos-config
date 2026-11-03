{ pkgs, ... }:

let
  pname = "antigravity-tools";
  version = "5.0.0";
  src = pkgs.fetchurl {
    url = "https://github.com/lbjlaq/Antigravity-Manager/releases/download/v${version}/Antigravity.Tools_${version}_amd64.AppImage";
    hash = "sha256-XkHel60IvxOrtDr0H6u2DeOQPHK1pYwoxQpEIp+fqpQ=";
  };
  appimageContents = pkgs.appimageTools.extract {
    inherit pname version src;
  };
  antigravity-manager-pkg = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraPkgs = pkgs: with pkgs; [
      webkitgtk_4_1
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      openssl
      libappindicator-gtk3
    ];
    extraInstallCommands = ''
      install -m 444 -D "${appimageContents}/usr/share/applications/Antigravity Tools.desktop" "$out/share/applications/antigravity-tools.desktop"
      cp -r ${appimageContents}/usr/share/icons $out/share/
      ln -s $out/bin/antigravity-tools $out/bin/antigravity-manager
      ln -s $out/bin/antigravity-tools $out/bin/antigravity-manage
      ln -s $out/bin/antigravity-tools $out/bin/at
    '';
  };
in
{
  home.packages = [
    antigravity-manager-pkg
  ];

  xdg.desktopEntries."antigravity-tools" = {
    name = "Antigravity Tools";
    genericName = "Antigravity Account Manager & Switcher";
    comment = "Professional Antigravity Account Manager & Switcher";
    exec = "antigravity-tools";
    icon = "antigravity-tools";
    categories = [
      "Utility"
      "Development"
    ];
    terminal = false;
    type = "Application";
    settings = {
      StartupWMClass = "antigravity-tools";
      Keywords = "antigravity;manage;manager;tools;account;switcher;agy;";
    };
  };
}
