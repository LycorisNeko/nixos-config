{ pkgs, ... }:
{
  programs.fish.enable = true;

  users.users.AnyNeko = {
    isNormalUser = true;
    description = "AnyNeko";
    group = "AnyNeko"; # 明确指定主组名称
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
      "wireshark"
      "scanner" # SANE 扫描仪访问权限
      "lp"      # 打印机与复合扫描设备权限
      "libvirtd"
      "kvm"
      "qemu-libvirtd"
      "adbusers" # Android USB 调试与设备访问权限
      "usbmux"   # iPhone/iPad USB 通信权限
    ];
    # shell = pkgs.bash;
    shell = pkgs.fish;
    homeMode = "711";
  };

  # 建立对应的同名主组
  users.groups.AnyNeko = {};
}