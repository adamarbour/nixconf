{
  perSystem.treefmt = {
    projectRootFile = "flake.nix";
    programs = {
      nixfmt.enable = true;
    };
    settings.on-unmatched = "info";
  };
}
