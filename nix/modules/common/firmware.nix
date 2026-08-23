{
  flake.modules.nixos.common = { lib, ... }: {
    services.fwupd.enable = lib.mkDefault true;
    hardware.enableAllFirmware = lib.mkDefault true;
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    nixpkgs.config.allowUnfree = lib.mkDefault true; # enableAllFirmware depends on this
  };
}
