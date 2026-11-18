{ config, pkgs, lib, ... }:

# CPU 名称欺骗模块
# 将 /proc/cpuinfo 中的 model name 替换为目标 CPU 名称，
# 使所有读取 /proc/cpuinfo 的软件（lscpu、fastfetch、htop、neofetch、Steam 等）
# 都显示伪造的 CPU 型号。
#
# 实现方式：
#   1. 在系统启动后读取真实 /proc/cpuinfo
#   2. 用 sed 替换 model name 字段
#   3. 将结果写入 /run/fake-cpuinfo
#   4. 用 bind mount 覆盖 /proc/cpuinfo（通过 nsenter 进入 mount namespace）
#
# 注意：/proc 是内核导出的虚拟文件系统，不能直接 bind mount 覆盖单个文件；
# 需要在 host mount namespace 中操作，这里用 unshare/nsenter 方案。
# 更简单可靠的方案：用 LD_PRELOAD 或 binfmt 拦截，但最广泛兼容的方式是
# 使用 systemd-mount 在 /proc/cpuinfo 上叠加 bind mount。

let
  targetCPUName = "Intel(R) Xeon(R) Platinum 8368 CPU @ 2.40GHz";

  # 生成假 cpuinfo 的脚本
  # 读取真实 cpuinfo，仅替换 model name 行，保留其他所有字段（核心数、flags 等）
  spoofScript = pkgs.writeShellScript "spoof-cpuinfo" ''
    set -euo pipefail

    FAKE=/run/fake-cpuinfo

    # 读取真实 cpuinfo，替换 model name 字段
    sed 's/^model name\s*:.*$/model name\t: ${targetCPUName}/' \
        /proc/cpuinfo > "$FAKE"

    chmod 444 "$FAKE"

    # 在当前 mount namespace（PID 1 的 namespace）中执行 bind mount
    # 覆盖 /proc/cpuinfo
    ${pkgs.util-linux}/bin/mount --bind "$FAKE" /proc/cpuinfo
  '';

in
{
  # 在 boot 完成、/proc 挂载后立即执行
  systemd.services.cpu-spoof = {
    description = "Spoof /proc/cpuinfo CPU model name";
    wantedBy    = [ "sysinit.target" ];
    after       = [ "systemd-remount-fs.service" ];
    before      = [ "basic.target" ];

    serviceConfig = {
      Type            = "oneshot";
      RemainAfterExit = true;
      ExecStart       = spoofScript;

      # 需要 CAP_SYS_ADMIN 才能执行 bind mount
      # 在 NixOS systemd 服务中默认有足够权限
    };

    # 确保服务在每次启动时都运行
    unitConfig = {
      ConditionPathExists = "/proc/cpuinfo";
    };
  };
}
