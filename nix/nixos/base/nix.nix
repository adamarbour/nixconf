{ inputs, ... }:
{
  flake.modules.nixos.base = { pkgs, lib, config, ... }: {

    # https://github.com/NixOS/nixpkgs/blob/eca4605163a534aed1981de0f5f1d7d7639d1640/nixos/modules/programs/environment.nix#L18
    environment.variables.NIXPKGS_CONFIG = lib.mkForce "";

    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    nix.channel.enable = false;
    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    nix.settings = {
      trusted-users = [ "root" "@wheel" ];

      download-buffer-size = 1024 * 1024 * 1024;
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 20 * 1024 * 1024 * 1024;

      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
        "git-hashing"
      ];

      sandbox = pkgs.stdenv.hostPlatform.isLinux;

      max-jobs = "auto";

      keep-going = true;
      log-lines = 30;

      use-registries = true;
      flake-registry = "";

      warn-dirty = false;
      http-connections = 50;

      keep-derivations = true;
      keep-outputs = true;

      use-xdg-base-directories = true;

      accept-flake-config = false;
    };

  };
}
