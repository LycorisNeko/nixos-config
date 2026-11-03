{ ... }:
{
  home.file.".local/bin/niri-screenshot.sh" = {
    source = ../scripts/niri-screenshot.sh;
    executable = true;
  };

  # GitHub 用户信息与凭据助手配置
  home.file.".gitconfig" = {
    force = true;
    text = ''
      [user]
        name = LycorisNeko
        email = lycorisneko2023@gmail.com
      [credential]
        # 使用系统 GNOME Keyring 保存 HTTPS 凭据，避免写入明文文件
        helper = libsecret
    '';
  };
}
