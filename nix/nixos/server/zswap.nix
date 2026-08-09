{
  flake.modules.nixos.server = { lib, ... }: {

    boot.zswap = {
      maxPoolPercent = lib.mkDefault 15;
    };

  };
}
