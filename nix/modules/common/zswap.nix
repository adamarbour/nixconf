{
  flake.modules.nixos.common = { lib, config, ... }: {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
      memoryMax = 4 * 1024 * 1024 * 1024; # 4GB
      priority = 100;
    };
  };
}
