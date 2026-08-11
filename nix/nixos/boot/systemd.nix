{ inputs, self, ... }:
{
  flake.modules.nixos.boot-systemd = { lib, ... }: {

    boot.loader.grub.enable = lib.mkForce false;
    boot.loader.systemd-boot = {
      enable = lib.mkDefault true;
    };

  };
}
