{ config, ... }:
{
  # NVIDIA GeForce RTX 4090 48GB (Ada Lovelace) 驱动配置
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Ada Lovelace 架构支持开源内核模块（>= 驱动 560），但专有驱动稳定性更好
    open = false;

    # stable 驱动对 Ada Lovelace (RTX 4090) 支持完善
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # 电源管理：防止休眠/唤醒后黑屏
    powerManagement.enable = true;

    # nvidia-settings GUI 工具
    nvidiaSettings = true;

    # 纯独显无需 PRIME Offload
    prime.offload.enable = false;

    # 启用 DRM KMS（Wayland / Hyprland / Niri 必须）
    modesetting.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam / Wine / Proton 32 位支持
  };
}
