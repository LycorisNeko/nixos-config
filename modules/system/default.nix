{ ... }:
{

  imports = [

    ./audio.nix
    ./boot.nix
    ./fonts.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./nvidia.nix
    ./packages.nix
    ./services.nix
    ./users.nix
    ./virtualisation.nix
    ./ai.nix
    ./cpu-spoof.nix  # CPU 名称欺骗：伪装为 Xeon Platinum 8368

  ];

}
