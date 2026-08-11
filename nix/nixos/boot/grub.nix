{ inputs, self, ... }:
{
  flake.modules.nixos.boot-grub = { lib, ... }: {

    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.loader.grub = {
      enable = lib.mkDefault true;
      efiSupport = lib.mkDefault false;
    };

  };
}
