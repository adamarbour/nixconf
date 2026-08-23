{
  flake.modules.nixos.common = { lib, ... }: {
    zramSwap = {
      enable = lib.mkDefault true;
      algorithm = "zstd";
      memoryPercent = 50;
      memoryMax = 4 * 1024 * 1024 * 1024; # 4GB
      priority = 100;
    };
  };
}
