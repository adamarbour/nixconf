{ inputs, self, ... }:
{
  flake.modules.nixos.server = { pkgs, lib, ... }: {

    imports = with inputs; [
      lanzaboote.nixosModules.lanzaboote
    ];

    environment.systemPackages = [
      pkgs.sbctl
    ];

    boot = {
      loader.systemd-boot.enable = lib.mkForce false;
      loader.grub.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
        autoGenerateKeys.enable = lib.mkDefault true;
      };
    };

  };
}
