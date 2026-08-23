{ inputs, ... }:
{
  flake.modules.nixos.common = { pkgs, lib, ... }: {
    users.groups.deploy = {}; # we use this for trusted users

    nix = {
      channel.enable = false;

      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      settings = {
        trusted-users = [ "root" "@deploy" ];

        experimental-features = [
          "nix-command"
          "flakes"
          "auto-allocate-uids"
          "cgroups"
          "git-hashing"
        ];

        min-free = 5 * 1024 * 1024 * 1024;
        max-free = 20 * 1024 * 1024 * 1024;

        sandbox = pkgs.stdenv.hostPlatform.isLinux;
        builders-use-substitutes = true;
        fallback = true;

        max-jobs = "auto";
        keep-going = true;
        log-lines = 30;
        use-registries = true;
        warn-dirty = false;
        use-xdg-base-directories = true;
        accept-flake-config = false;
      };

      optimise = {
        automatic = true;
        dates = [ "weekly" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
    };

    system.stateVersion = "26.05";
  };
}
