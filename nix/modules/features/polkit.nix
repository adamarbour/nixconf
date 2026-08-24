{
  flake.modules.nixos.has-polkit = {
    security = {
      polkit = {
        enable = true;

        # NixOS already defaults this to wheel, but make our
        # administrative policy explicit.
        adminIdentities = [
          "unix-group:wheel"
        ];
      };
      wrappers.pkexec.enable = false;
    };
  };
}
