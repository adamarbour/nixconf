{ inputs, self, ... }:
{
  flake.modules.nixos.gaming = { pkgs, lib, ... }: {
    imports = [
      self.modules.nixos.hw-controllers
    ];

    hardware.graphics.enable32Bit = lib.mkDefault true;

    programs.steam = {
      enable = lib.mkDefault true;
      protontricks.enable = lib.mkDefault true;
      remotePlay.openFirewall = lib.mkDefault true;
      dedicatedServer.openFirewall = lib.mkDefault false;

      package = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [ gamemode ];
      };

      gamescopeSession.enable = lib.mkDefault false;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    programs.gamescope = {
      enable = lib.mkDefault true;
      capSysNice = true;
    };

    programs.gamemode = {
      enable = lib.mkDefault true;
    };

    environment.systemPackages = with pkgs; [
      lutris
      mangohud
      protonplus
      dxvk
      # vulkan frame generation
      lsfg-vk
      lsfg-vk-ui
    ];

  };
}
