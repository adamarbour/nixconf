{
  flake.modules.nixos.programs =
    { lib, config, ... }:
    let
      cfg = config.my.programs;
    in
    {

      options.my.programs.direnv = {
        enable = lib.mkEnableOption "enable direnv";
      };

      programs.direnv = lib.mkIf cfg.direnv.enable {
        enable = true;
        nix-direnv.enable = true;
      };

    };
}
