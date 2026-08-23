{ inputs, self, ... }: let
  inherit (self.lib) mkNixos;
in {
  flake.modules.nixos.hellespont = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      desktop
      disko
      self.diskoConfigurations.hellespont
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    services.xserver.enable = true;

    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    programs.firefox.enable = true;
  };

  flake.nixosConfigurations = mkNixos "x86_64-linux" "hellespont";
}
