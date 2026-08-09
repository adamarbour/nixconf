{
  flake.modules.nixos.base = { pkgs, lib, config, ... }: {

    security = {
      run0 = {
        enable = true;
        wheelNeedsPassword = false;
        sudo-shim.enable = true;
      };

      sudo.enable = false;
      sudo-rs.enable = false;
    };

  };
}
