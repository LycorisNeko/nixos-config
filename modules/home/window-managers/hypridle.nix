{ pkgs, ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "noctalia-sync || true; pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        {
          timeout = 3600; # 60 min (1 小时)
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 3605; # 锁屏后关闭显示输出（避免锁屏动画空耗功耗）
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
      ];
    };
  };
}
