{
  flake.modules.nixos.my-programs =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.my.programs;
    in
    {
      options.my.programs.devenv = {
        enable = lib.mkEnableOption "enable devenv";
      };

      config = lib.mkIf cfg.devenv.enable {
        environment.systemPackages = with pkgs; [
          devenv
        ];

        programs = {
          nix-ld.enable = true;
        };
      };
    };
}
