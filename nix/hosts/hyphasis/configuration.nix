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
      hw-gpu-nvidia-prime
      # disk
      disko
      self.diskoConfigurations.hyphasis
      # features
      has-wifi
    ];

    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

    services = {
      xserver.enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma6.enable = true;
    };

    programs.firefox.enable = true;

    environment.systemPackages = [
      pkgs.llm-agents.pi
    ];
  };

  flake.nixosConfigurations = mkNixos "x86_64-linux" "hyphasis";
}
