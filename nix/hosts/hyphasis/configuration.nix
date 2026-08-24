{ self, ... }:
let
  inherit (self.lib) mkNixos;
in
{
  flake.modules.nixos.hyphasis = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      # profiles / roles
      laptop
      # hardware
      hw-cpu-intel
      hw-gpu-intel
      #      hw-gpu-nvidia-prime
      hw-focusrite-scarlett
      # disk
      disko
      self.diskoConfigurations.hyphasis
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

  flake.nixosConfigurations = mkNixos "x86_64-linux" "hyphasis";
}
