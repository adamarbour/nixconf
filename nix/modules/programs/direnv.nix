{
  flake.modules.nixos.my-programs =
    { lib, config, ... }:
    let
      cfg = config.my.programs;
    in
    {
      options.my.programs.direnv = {
        enable = lib.mkEnableOption "enable direnv";
      };

      config = lib.mkIf cfg.direnv.enable {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };
      };
    };
}
