{
  flake.modules.nixos.base = { lib, config, ... }: {
    boot.tmp = {
      useTmpfs = lib.mkDefault true;
      tmpfsHugeMemoryPages = lib.mkDefault "within_size";
      cleanOnBoot = lib.mkDefault (!config.boot.tmp.useTmpfs);
    };
  };
}
