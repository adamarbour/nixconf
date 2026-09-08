{
  flake.modules.nixos.my-programs =
    { lib, config, ... }:
    let
      cfg = config.my.programs;
    in
    {
      options.my.programs.fish = {
        enable = lib.mkEnableOption "enable fish shell";
      };

      config = lib.mkIf cfg.fish.enable {
        environment.systemPackages = [ pkgs.fzf ];
        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            # native fzf integration — no plugin manager needed.
            # Ctrl+R: fuzzy history search
            # Ctrl+T: fuzzy file search
            # Alt+C:  fuzzy cd
            if status is-interactive; and type -q fzf
              fzf --fish | source
            end
          '';
        };
      };
    };
}
