{ self, ... }:
{
  flake.modules.nixos.policy-u2f-yubikey =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (config.security) polkit;

      yubikeyAuth = {
        enable = true;
        control = "sufficient";
      };
    in
    {
      imports = with self.modules.nixos; [
        has-yubikey # ensure
      ];

      security = {
        pam = {
          # we do not want it set globally
          u2f = {
            enable = false;
            settings = {
              authfile = "/etc/u2f-mappings";
              cue = true;
              userpresence = 1;
              pinverifcation = 1;
              userverification = 0;
            };
          };
          # set it for sudo
          services = lib.mkMerge [
            {
              sudo.u2f = yubikeyAuth;
              sudo-i.u2f = yubikeyAuth;
            }
            (lib.mkIf polkit.enable {
              polkit-1.u2f = yubikeyAuth;
            })
          ];
        };
      };

      systemd.services = lib.mkIf polkit.enable {
        "polkit-agent-helper@".serviceConfig = {
          PrivateDevices = false;

          DeviceAllow = [
            "/dev/urandom r"
            "char-hidraw rw"
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        pam_u2f
      ];

      # declare my mappings in the policy
      environment.etc."u2f-mappings".text = ''
        adam:kspT18TtNCTHC0cw3HapDp+xrOM6yQ/kDOU1vehTylRBJYG9SM5XMoiXEB4wfSl4Hmh43Pb+f11MNjOTmb2dtQ==,2wrSS5HF1mNZ1/0tbC1DoGvwN5dUKlO7muNLVRkZaUKSGLlj9eX/TkB0MGKLAS6PC8JgsUcMiLz9OHGx8dRhbA==,es256,+presence+pin
        adam:/nHvI9jzXNz5TLoAb0NqLZwm8ylDHpOn9PTyAmMEoxXCBRybZDu4A4KfpDx01FGn/2C4l2mvDSkYKSmGVAaTGQ==,zokzZsQ+ZyKmDigr7wCKWxW0tnR5jqOBDq6aDBiqxPXHMHVCUYeHEsMGLhEW9HRQ8Tzs9OGgCILGgBU8BHHZtg==,es256,+presence+pin
      '';
    };
}
