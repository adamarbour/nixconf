{
  flake.modules.nixos.common = { lib, config, ... }: {
    boot.tmp = {
      useTmpfs = true;
      tmpfsHugeMemoryPages = lib.mkDefault "within_size";
      cleanOnBoot = !config.boot.tmp.useTmpfs;
    };
  };
}
