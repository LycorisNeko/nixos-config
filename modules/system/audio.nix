{ ... }:
{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  # PCIe 独立声卡（技嘉 MU72-SU0 无板载音频，依赖 PCIe 声卡输出）
  # PipeWire 自动识别声卡，无需额外 ALSA 配置
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
