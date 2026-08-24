{
  flake.modules.nixos.common = {
    security = {
      sudo.enable = false;
      sudo-rs = {
        enable = true;
        # Only wheel members may execute the sudo binary at all.
        execWheelOnly = true;
        wheelNeedsPassword = true;
      };
    };
  };
}
