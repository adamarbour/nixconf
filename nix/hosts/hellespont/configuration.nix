{ self, ... }:
let
  inherit (self.lib) mkNixos;
in
{
  flake.modules.nixos.hellespont = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      # profiles / roles
      desktop
      # hardware
      hw-cpu-amd
      hw-gpu-amd
      disko
      self.diskoConfigurations.hellespont
      # features
      has-controllers

    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;

    services = {
      xserver.enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };

    programs.firefox.enable = true;
  };

  flake.nixosConfigurations = mkNixos "x86_64-linux" "hellespont";
}
