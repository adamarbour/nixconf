{
  flake.modules.nixos.common = {
    users.groups.deploy = { };
    security = {
      sudo.enable = false;
      sudo-rs = {
        enable = true;
        # Only wheel members may execute the sudo binary at all.
        execWheelOnly = true;
        wheelNeedsPassword = true;

        extraRules = [
          {
            groups = [ "deploy" ];
            commands = [
              {
                command = "ALL";
                options = [ "NOPASSWD" ];
              }
            ];
          }
        ];
      };
    };
  };
}
