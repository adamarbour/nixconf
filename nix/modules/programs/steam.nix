{
  flake.modules.nixos.my-programs =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.my.programs;
    in
    {
      options.my.programs.steam = {
        enable = lib.mkEnableOption "enable steam package";
      };

      config = lib.mkIf cfg.steam.enable {
        programs = {
          steam = {
            enable = true;
            remotePlay.openFirewall = lib.mkDefault true;
            localNetworkGameTransfers.openFirewall = lib.mkDefault true;
            dedicatedServer.openFirewall = lib.mkDefault false;

            gamescopeSession.enable = lib.mkDefault true;
            protontricks.enable = lib.mkDefault true;
          };

          gamemode = {
            enable = true;
            settings = {
              general.renice = 10;
              gpu = {
                apply_gpu_optimisations = "accept-responsibility";
                amd_performance_level = "high";
              };
            };
          };

          gamescope = {
            enable = true;
            capSysNice = true;
          };
        };

        environment.systemPackages = with pkgs; [
          lutris
          mangohud
          mangojuice
          protonplus
          protontricks
        ];
      };
    };
}
