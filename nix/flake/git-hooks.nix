{
  perSystem.pre-commit.settings = { pkgs, config, ... }: {
    package = pkgs.prek;

    hooks = {
      treefmt = {
        enable = true;

        packageOverrides.treefmt = config.treefmt.build.wrapper;
      };

      deadnix.enable = true;
      statix.enable = true;

      check-added-large-files.enable = true;
      check-case-conflicts.enable = true;
      check-merge-conflicts.enable = true;
      check-symlinks.enable = true;

      detect-private-keys.enable = true;

      end-of-file-fixer.enable = true;
      trim-trailing-whitespace.enable = true;
    };
  };
}
