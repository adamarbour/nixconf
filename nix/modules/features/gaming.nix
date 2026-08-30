{
  flake.modules.nixos.has-gaming = { lib, ... }: {
    boot.kernel.sysctl."vm.max_map_count" = lib.mkForce 2147483642;

    hardware.graphics = {
      enable32Bit = true;
    };

    my.programs.steam.enable = true;
  };
}
