{
  flake.modules.nixos.base = { pkgs, lib, config, ... }: {
    boot.zswap = {
      enable = config.swapDevices != [ ];
    };
  };
}
